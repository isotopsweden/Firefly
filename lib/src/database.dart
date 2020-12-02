import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firefly/src/models/error.dart';
import 'package:firefly/src/models/query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final BuildContext context;

  Database(this.context);

  Future<Stream<QuerySnapshot>> collectionStream(
      String collection, Queryyy query) async {
    final instance = Provider.of<FirebaseFirestore>(context);
    var collectionRef = instance.collection(collection);
    Stream<QuerySnapshot> snapshots;

    final defaultQuery = Queryyy('age')..isEqualTo(2);
    final extraQuery = Queryyy('name')..isEqualTo('Teal');

    snapshots =
        _mapQueries(collectionRef, [defaultQuery, extraQuery]).snapshots();

    print("3: $snapshots");
    return snapshots;
  }

  Query _mapQueries(CollectionReference collectionRef, List<Queryyy> queries) {
    Query a = collectionRef;

    if (queries != null) {
      queries.forEach((element) {
        print("1: ${element.method}");
        a = _mapMethodToFirebase(a, element);
        print("1.5: $a");
      });
      print("2: $a");
      return a;
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

  Future<bool> _checkIfDocsExist(Stream<QuerySnapshot> snapshots) async {
    final docsAreEmpty = await snapshots.isEmpty;
    return !docsAreEmpty;
  }
}
