import 'package:firefly/src/firefly_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firefly/src/models/query.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;

class Database<T> {
  final BuildContext context;

  Database(this.context);

  Future<Stream<QuerySnapshot>> collectionStream(
    String collection,
    List<Query>? queries,
    bool? excludeFromDefultQueries,
    Function(T)? onChange,
  ) async {
    var defaultQuery;
    var snapshots;
    var hasRunInitial = false;

    List<Query> queryList = [];
    FirebaseFirestore instance = Provider.of<FirebaseFirestore>(context);
    List<FireflyDataBuilder> builders =
        Provider.of<List<FireflyDataBuilder>>(context);
    CollectionReference collectionRef = instance.collection(collection);

    if (excludeFromDefultQueries != null && !excludeFromDefultQueries) {
      try {
        defaultQuery = Provider.of<List<Query>>(context);
      } catch (_) {}

      if (defaultQuery != null) {
        defaultQuery.forEach((q) => queryList.add(q));
      }
    }

    if (queries != null) {
      queries.forEach((q) => queryList.add(q));
    }

    snapshots = queryList.isNotEmpty
        ? _mapQueries(collectionRef, [...queryList]).snapshots()
        : collectionRef.snapshots();

    if (onChange != null) {
      snapshots.listen(
        (data) => hasRunInitial
            ? _handleOnChange(data, onChange, builders)
            : hasRunInitial = true,
      );
    }

    return snapshots;
  }

  _handleOnChange(
    QuerySnapshot data,
    Function(T) handler,
    List<FireflyDataBuilder> builders,
  ) {
    final changedData = data.docChanges.first.doc.data();
    final List<FireflyDataBuilder> result = builders
        .where((datamodel) => datamodel.model.toString() == T.toString())
        .toList();

    return handler(result.first.builder(changedData));
  }

  _mapQueries(collectionRef, List<Query> queries) {
    var returnQuery = collectionRef;

    queries.forEach(
        (element) => returnQuery = _mapMethodToFirebase(returnQuery, element));

    return returnQuery;
  }

  _mapMethodToFirebase(collectionRef, Query query) {
    switch (query.method) {
      case Queries.isEqualTo:
        return collectionRef.where(query.value, isEqualTo: query.comparer);
      case Queries.isLessThan:
        return collectionRef.where(query.value, isLessThan: query.comparer);
      case Queries.isLessThanOrEqualTo:
        return collectionRef.where(query.value,
            isLessThanOrEqualTo: query.comparer);
      case Queries.isGreaterThan:
        return collectionRef.where(query.value, isGreaterThan: query.comparer);
      case Queries.isGreaterThanOrEqualTo:
        return collectionRef.where(query.value,
            isGreaterThanOrEqualTo: query.comparer);
      case Queries.arrayContains:
        return collectionRef.where(query.value, arrayContains: query.comparer);
      case Queries.arrayContainsAny:
        return collectionRef.where(query.value,
            arrayContainsAny: query.comparer);
      case Queries.whereIn:
        return collectionRef.where(query.value, whereIn: query.comparer);
      default:
        return collectionRef;
    }
  }
}
