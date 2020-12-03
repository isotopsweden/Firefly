import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_core/firebase_core.dart';
import 'package:firefly/firefly.dart';
import 'package:flutter/material.dart';

/// Create yout models to match your Firestore Documents.
class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(json['name'], json['number']);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Setup(),
    );
  }
}

/// Make sure that you initialize Firebase before using any Firefly Widgets.
class Setup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('There was an error!');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final firestore = FirebaseFirestore.instance;

          /// The [FireflyDataBuilder] needs the model and
          /// a constuctor that handles Json data.
          final buildList = [
            FireflyDataBuilder(
              model: Person,
              builder: (json) => Person.fromJson(json),
            )
          ];

          /// Once Firebase is initialized you
          /// need to wrap your app in a [FireflyProvider].
          /// It need an instance of your Firestore and
          /// a list of [FireflyDataBuilders] for creating
          /// objects to return.
          /// If you want queries used on all the request,
          /// use the [defaultQueries] parameter.
          return FireflyProvider(
            instance: firestore,
            modelbuilderList: buildList,
            child: App(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('Loading...');
      },
    );
  }
}

/// Then use the [Firefly] Widget anywhere you want.
/// Remember to pass the Model as [Firefly<Model>] so
/// so you know what to expect in the [builders] state.
/// Tell Firefly what collection you want and get the
/// data constructed as a List in the builder callback.
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Firefly<Person>(
          collection: 'persons',
          builder: (context, state) => ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) => Text(state[index].name),
          ),
        ),
      ),
    );
  }
}

/// Alternatively you can use the shorthand [listBuilder] to
/// get a already created [ListView] with objects.
class ListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Firefly<Person>(
          collection: 'players',
          listBuilder: (context, state, index) => Text(state[index].name),
        ),
      ),
    );
  }
}

/// You can also query the Firestore directly on the widget.
/// Use the [queries] parameter and the [Query] model.
/// You can chain multiple queries
class QueryFirestore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Firefly<Person>(
          collection: 'players',
          listBuilder: (context, state, index) => Text(state[index].name),
          queries: [Query('age')..isEqualTo(22)],
        ),
      ),
    );
  }
}

/// Want to show another widget when the Firestore is
/// loading. Just override the [loading] parameter with
/// any Widget you like.
class OverrideLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Firefly<Person>(
          collection: 'players',
          listBuilder: (context, state, index) => Text(state[index].name),
          loading: Container(
            width: 200,
            height: 200,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

/// If you get an error reciving your data, handle it
/// with the [error] parameter.
class HandleErrors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Firefly<Person>(
          collection: 'players',
          listBuilder: (context, state, index) => Text(state[index].name),
          error: (error) => Text(error.toString()),
        ),
      ),
    );
  }
}
