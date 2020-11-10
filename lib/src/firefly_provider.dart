import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FireflyDataBuilder {
  final Type model;
  final Function builder;

  FireflyDataBuilder({this.model, this.builder});
}

class FireflyProvider extends StatelessWidget {
  final Widget child;
  final List<FireflyDataBuilder> modelbuilderList;

  const FireflyProvider({Key key, this.child, this.modelbuilderList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<List<FireflyDataBuilder>>(
      create: (_) => [...modelbuilderList],
      child: child,
    );
  }
}
