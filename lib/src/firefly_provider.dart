import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireflyDataBuilder {
  final Type model;
  final Function builder;

  FireflyDataBuilder({this.model, this.builder});
}

class FireflyProvider extends StatelessWidget {
  final Widget child;
  final FirebaseFirestore instance;
  final List<FireflyDataBuilder> modelbuilderList;

  const FireflyProvider({
    Key key,
    this.child,
    this.modelbuilderList,
    @required this.instance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseFirestore>(create: (_) => instance),
        Provider<List<FireflyDataBuilder>>(
            create: (_) => [...modelbuilderList]),
      ],
      child: child,
    );
  }
}
