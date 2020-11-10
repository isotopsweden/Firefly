import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firefly/firefly.dart';

import 'car.dart';
import 'firefly_fly.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final modelbuilders = [
    FireflyDataBuilder(
      model: Fireflyfly,
      builder: (json) => Fireflyfly.fromJson(json),
    ),
    FireflyDataBuilder(
      model: Car,
      builder: (json) => Car.fromJson(json),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firefly Dev App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FireflyProvider(
              modelbuilderList: modelbuilders,
              child: App(),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firefly Development'),
      ),
      body: Center(
        child: Firefly<Car>(
          collection: 'cars',
          error: (error) => Text(error),
          listBuilder: (_, state, i) => Text(state[i].type),
        ),
      ),
    );
  }
}
