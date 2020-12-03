<p align="center">
<img src="https://raw.githubusercontent.com/isotopsweden/Firefly/master/assets/firefly_logo.png" alt="Firefly Package Logo" />
</p

---

Create beautiful [Flutter](https://flutter.dev) widget trees using this handy [Firestore](https://firebase.google.com/products/firestore) builder widget. 

## Extras
Using VS Code? There is a [snippets extension](https://marketplace.visualstudio.com/items?itemName=crljvr.firefly-snippets/ "Firefly snippets extension") for Firefly!

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
          return Text('THERE WAS AN ERROR...');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return FireflyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Text('LOADING...');
      },
    );
  }
```

### Use the FireflyProvider

The `FireflyProvider` will provide all Firefly widgets with the correct instance of your Firestore database. It also needs a list of `FireflyDataBuilder`. The purpose of the FireflyDataBuilder is to provide Firefly with the correct model and constuctor so it can create your objects before you can access them in the various builder parameters.


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
The type object expected to accessed in the various `builder` parametes. Here we expect a Person by adding `<Person>`

We can then use the `builder` to get a list of `Person` objects, here described as `state`.


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

___You can´t combine many builders, so remember to only use one per Firefly widget.___


```dart
Firefly<Person>(
  collection: 'persons',
  listBuilder: (context, state, index) => Text(state[index].name),
),
```

### Querying

You can also query the Firestore directly on the widget. Use the `query` parameter and the `Query` model.

___Just make sure you hide the Firestore Query in your import with:___

`import 'package:cloud_firestore/cloud_firestore.dart' hide Query;`


```dart
Firefly<Person>(
  collection: 'persons',
  listBuilder: (context, state, index) => Text(state[index].name),
  queries: [Query('age')..isEqualTo(22)],
),
```

**Default queries** can be defined on the FireflyProvider. These will be applied on all usages of the Firefly widget.

```dart
FireflyProvider(
  defaultQueries: [Query('age')..isEqualTo(22)],
  instance: FirebaseFirestore.instance,
  modelbuilderList: [...],
  child: ...
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

If you get an error receiving your data, handle it with the `error` parameter.


```dart
Firefly<Person>(
  collection: 'players',
  listBuilder: (context, state, index) => Text(state[index].name),
  error: (error) => Text(error.toString()),
),
```
