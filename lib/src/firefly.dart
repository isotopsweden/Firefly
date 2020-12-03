import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firefly/src/models/query.dart';
import 'package:firefly/src/database.dart';
import 'package:firefly/src/firefly_provider.dart';

class Firefly<@required T> extends StatelessWidget {
  /// Pass the name of the Firestore Collection and
  /// expect constructed objects in the builder callbacks.
  ///
  /// Its required to pass a type [<T>] so Firefly
  /// knows what to constuct.

  final String collection;
  final List<Query> queries;
  final Widget loading;
  final Function(dynamic) error;
  final Function(BuildContext, List<T>) builder;
  final Function(BuildContext, List<T>, int) listBuilder;
  final bool excludeFromDefultQueries;

  const Firefly(
      {@required this.collection,
      this.queries,
      this.loading,
      this.error,
      this.listBuilder,
      this.builder,
      this.excludeFromDefultQueries = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Database(context)
          .collectionStream(collection, queries, excludeFromDefultQueries),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return snapshot.hasError
                ? _buildHandleError(snapshot.error)
                : _buildStreamResult(snapshot.data);

          default:
            return _buildHandleLoading();
        }
      },
    );
  }

  StreamBuilder _buildStreamResult(Stream<QuerySnapshot> stream) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return snapshot.hasError
                ? _buildHandleError(snapshot.error)
                : _buildSnapshotResult(context, snapshot.data);
          default:
            return _buildHandleLoading();
        }
      },
    );
  }

  // Mapping and data manipulation

  List<T> _mapStreamToState(QuerySnapshot snapshot, BuildContext context) {
    final documentList = snapshot.docs;
    if (documentList.length != 0) {
      return List<T>.from(documentList
          .map((snapshot) => _mapSnapshotToModel(snapshot, context))
          .toList());
    } else {
      return List<T>.from(documentList.toList());
    }
  }

  _mapSnapshotToModel(DocumentSnapshot snapshot, BuildContext context) {
    final List<FireflyDataBuilder> builders =
        Provider.of<List<FireflyDataBuilder>>(context);

    final List<FireflyDataBuilder> result = builders
        .where((datamodel) => datamodel.model.toString() == T.toString())
        .toList();

    return result.first.builder(snapshot.data());
  }

  // Validation

  bool _nullValidator(value) {
    return value != null ? true : false;
  }

  // Response builders

  dynamic _buildSnapshotResult(BuildContext context, QuerySnapshot snapshot) {
    if (_nullValidator(builder)) {
      return builder(context, _mapStreamToState(snapshot, context));
    }

    if (_nullValidator(listBuilder)) {
      return _buildListBuilder(snapshot, context);
    }
  }

  ListView _buildListBuilder(QuerySnapshot snapshot, context) {
    final state = _mapStreamToState(snapshot, context);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: state.length,
      itemBuilder: (context, index) => listBuilder(context, state, index),
    );
  }

  Widget _buildHandleError(error) {
    return error(error);
  }

  _buildHandleLoading() {
    return _nullValidator(loading) ? loading : Text("LOADING...");
  }
}
