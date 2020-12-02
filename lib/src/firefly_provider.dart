import 'package:firefly/firefly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireflyDataBuilder {
  final Type model;
  final Function builder;

  FireflyDataBuilder({this.model, this.builder});
}

class FireflyProvider extends StatelessWidget {
  /// Handles the Firesore instance so it can be accessed from
  /// all the Firefly widgets.
  ///
  /// Also need a list of [FireflyDataBuilder] so the Firefly
  /// widgets know how to create objects.
  final Widget child;
  final FirebaseFirestore instance;
  // final List<Queryyy> defaultQueries;
  final List<FireflyDataBuilder> modelbuilderList;

  const FireflyProvider({
    Key key,
    this.child,
    this.modelbuilderList,
    // this.defaultQueries,
    @required this.instance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>(create: (_) => instance),
        // Provider<List<Queryyy>>(create: (_) => defaultQueries),
        Provider<List<FireflyDataBuilder>>(
            create: (_) => [...modelbuilderList]),
      ],
      child: child,
    );
  }
}
