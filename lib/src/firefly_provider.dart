import 'package:firefly/firefly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Query;

class FireflyDataBuilder {
  final Type model;
  final Function builder;

  FireflyDataBuilder({
    required this.model,
    required this.builder,
  });
}

class FireflyProvider extends StatelessWidget {
  /// Handles the Firesore instance so it can be accessed from
  /// all the Firefly widgets.
  ///
  /// Also need a list of [FireflyDataBuilder] so the Firefly
  /// widgets know how to create objects.
  ///
  /// You can add a list of [Query] to be applied on all
  /// requests using the [defaultQueries] parameter.
  final Widget child;
  final List<Query>? defaultQueries;
  final FirebaseFirestore instance;
  final List<FireflyDataBuilder> modelbuilderList;

  const FireflyProvider({
    Key? key,
    this.defaultQueries,
    required this.child,
    required this.instance,
    required this.modelbuilderList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>(create: (_) => instance),
        if (defaultQueries != null)
          Provider<List<Query>>(create: (_) => [...defaultQueries!]),
        Provider<List<FireflyDataBuilder>>(
            create: (_) => [...modelbuilderList]),
      ],
      child: child,
    );
  }
}
