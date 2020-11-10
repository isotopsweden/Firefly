import 'package:cloud_firestore/cloud_firestore.dart' hide Query;

class Database {
  Database();

  Future<Stream<QuerySnapshot>> collectionStream(String collection) async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collection);

    return collectionRef.snapshots();
  }
}
