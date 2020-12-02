import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firefly/src/models/error.dart';
import 'package:firefly/src/models/query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final BuildContext context;

  Database(this.context);

  Future<Stream<QuerySnapshot>> collectionStream(
      String collection, List<Queryyy> queries) async {
    final queryList = [];

    FirebaseFirestore instance = Provider.of<FirebaseFirestore>(context);
    List<Queryyy> defaultQuery = Provider.of<List<Queryyy>>(context);
    CollectionReference collectionRef = instance.collection(collection);
    Stream<QuerySnapshot> snapshots;

    if (defaultQuery != null) {
      defaultQuery.forEach((q) => queryList.add(q));
    }

    if (queries != null) {
      queries.forEach((q) => queryList.add(q));
    }

    // KEEP WORKING HERE!

    snapshots = queryList.isNotEmpty
        ? _mapQueries(collectionRef, [...queryList]).snapshots()
        : collectionRef.snapshots();

    return snapshots;
  }

  Query _mapQueries(CollectionReference collectionRef, List<Queryyy> queries) {
    Query returnQuery = collectionRef;

    if (queries != null) {
      queries.forEach((element) {
        returnQuery = _mapMethodToFirebase(returnQuery, element);
      });
      return returnQuery;
    } else {
      return collectionRef;
    }
  }

  Query _mapMethodToFirebase(Query collectionRef, Queryyy query) {
    var collection;
    if (query != null) {
      switch (query.method) {
        case Queries.isEqualTo:
          collection =
              collectionRef.where(query.value, isEqualTo: query.comparer);
          break;
        case Queries.isLessThan:
          collection =
              collectionRef.where(query.value, isLessThan: query.comparer);
          break;
        case Queries.isLessThanOrEqualTo:
          collection = collectionRef.where(query.value,
              isLessThanOrEqualTo: query.comparer);
          break;
        case Queries.isGreaterThan:
          collection =
              collectionRef.where(query.value, isGreaterThan: query.comparer);
          break;
        case Queries.isGreaterThanOrEqualTo:
          collection = collectionRef.where(query.value,
              isGreaterThanOrEqualTo: query.comparer);
          break;
        case Queries.arrayContains:
          collection =
              collectionRef.where(query.value, arrayContains: query.comparer);
          break;
        case Queries.arrayContainsAny:
          collection = collectionRef.where(query.value,
              arrayContainsAny: query.comparer);
          break;
        case Queries.whereIn:
          collection =
              collectionRef.where(query.value, whereIn: query.comparer);
          break;
        default:
          collection = collectionRef;
      }

      return collection;
    } else {
      return collectionRef;
    }
  }
}
