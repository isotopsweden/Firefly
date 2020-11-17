<p align="center">
<img src="https://github.com/isotopsweden/Firefly/blob/master/assets/firefly_logo.png" height="600" alt="Firefly Package" />
</p

---

A lightweight [Flutter](https://flutter.dev) widget that allows for short and clean widget trees when interacting with data from your [Firestore](https://firebase.google.com/products/firestore) database.

## Usage

There is three steps to start using Firefly.

### Setup Firebase

We recommend following the [FlutterFire](https://firebase.flutter.dev/docs/overview) guide to setup your app with Firebase.

It´s important to setup Firebase before using any Firefly widgets.

We like to use a FutureBuilder to initialize Firebase.

```dart
Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text('ERROR');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return FireflyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('LOAD');
      },
    );
  }
```

### Use the FireflyProvider

The `FireflyProvider` will provide all Firefly widgets with the correct instance of your Firestore database. It also needs a list of `FireflyDataBuilder`. The purpose of the FireflyDataBuilder is to provide Firefly with the correct model and constuctor so it can create your objects before passing them back.

```dart
class FireflyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    final firestore = FirebaseFirestore.instance;
    
    final buildList = [
      FireflyDataBuilder(
        model: Person,
        builder: (json) => Person.fromJson(json),
      )
    ];
    
    return FireflyProvider(
      instance: firestore,
      modelbuilderList: buildList,
      child: App(),
    );
  }
}
```

### Finally, you can use Firefly

`Firefly` requires two things to work correctly.
The `collection` parameter is used so Firefly knows which Firestore Collection to retrive data from. 
The type of model expected to returned in the `builder`. Here we expect a Person by adding `<Person>`

We can then use the `builder` to get a list of created `Person`:s, here described as `state`.

```dart
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
```

## Using the Firefly widget

The Firefly widget has a bunch of parameters:

### listBuilder

The `builder` is one way to use retrive the created objects. But you can also use the shorthand `listBuilder` to get a already created `ListView` with objects.

You can´t combine many builders, so remember to only use one per Firefly widget.

```dart
Firefly<Person>(
  collection: 'persons',
  listBuilder: (context, state, index) => Text(state[index].name),
),
```

### Querying

You can also query the Firestore directly on the widget. Use the `query` parameter and the `Query` model.

Just make sure you hide the Firestore Query in your import with:

`import 'package:cloud_firestore/cloud_firestore.dart' hide Query;`

```dart
Firefly<Person>(
  collection: 'persons',
  listBuilder: (context, state, index) => Text(state[index].name),
  query: Query('age')..isEqualTo(22),
),
```

### Override Loading

Want to show another widget when the Firestore is loading. Just override the `loading` parameter with any widget you like.

```dart
Firefly<Person>(
  collection: 'players',
  listBuilder: (context, state, index) => Text(state[index].name),
  loading: Container(
    width: 200,
    height: 200,
    color: Colors.red,
  ),
),
```

### Handle Errors

If you get an error reciving your data, handle it with the `error` parameter.

```dart
Firefly<Person>(
  collection: 'players',
  listBuilder: (context, state, index) => Text(state[index].name),
  error: (error) => Text(error.toString()),
),
```
