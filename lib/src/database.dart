import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firefly/src/models/error.dart';
import 'package:firefly/src/models/query.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;

class Database {
  final BuildContext context;

  Database(this.context);

  Future<Stream<QuerySnapshot>> collectionStream(
      String collection, Query query) async {
    final instance = Provider.of<FirebaseFirestore>(context);
    var collectionRef = instance.collection(collection);
    Stream<QuerySnapshot> snapshots;

    if (query != null) {
      snapshots = _mapMethodToFirebase(collectionRef, query).snapshots();
    } else {
      snapshots = collectionRef.snapshots();
    }

    if (await _checkIfDocsExist(snapshots)) {
      buildInternalError(InternalError.noDocumentsExistError);
    }

    return snapshots;
  }

  _mapMethodToFirebase(CollectionReference collectionRef, Query query) {
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

  Future<bool> _checkIfDocsExist(Stream<QuerySnapshot> snapshots) async {
    final docsAreEmpty = await snapshots.isEmpty;
    return !docsAreEmpty;
  }
}
