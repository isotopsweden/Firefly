import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;

import '../firefly.dart';

class Firefly<@required T> extends StatelessWidget {
  final String collection;
  final Query query;
  final Widget loading;
  final Function(dynamic) error;
  final Function(BuildContext, List<T>) builder;
  final Function(BuildContext, List<T>, int) listBuilder;

  const Firefly({
    @required this.collection,
    this.query,
    this.loading,
    this.error,
    this.listBuilder,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Database(query).collectionStream(collection),
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

  // Mappning och data manipulation

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

  // Validering

  bool _nullValidator(value) {
    return value != null ? true : false;
  }

  // Response byggare

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
