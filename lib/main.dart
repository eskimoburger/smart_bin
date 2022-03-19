import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _database = FirebaseDatabase.instance.ref();
  String humidity = "Result go here";
  String temperature = "Result go here";
  String statuse = "Result go here";
  String cycle = "Result go here";
  String green = "Result go here";
  String red = "Result go here";
  String fillBin = "Result go here";
  late StreamSubscription _databaseSteam;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    _databaseSteam = _database.child("/DHT11/Humidity").onValue.listen((event) {
      final Object? _humidity = event.snapshot.value;
      setState(() {
        humidity = _humidity.toString();
      });
    });

    _databaseSteam = _database.child("/Cycle").onValue.listen((event) {
      final Object? _cycle = event.snapshot.value;
      setState(() {
        cycle = _cycle.toString();
      });
    });
    _databaseSteam =
        _database.child("/HC-SR04/FillBin").onValue.listen((event) {
      final Object? _fillBin = event.snapshot.value;
      setState(() {
        fillBin = _fillBin.toString();
      });
    });
    _databaseSteam = _database.child("/LED/Green").onValue.listen((event) {
      final Object? _green = event.snapshot.value;
      setState(() {
        green = _green.toString();
      });
    });
    _databaseSteam = _database.child("/LED/Red").onValue.listen((event) {
      final Object? _red = event.snapshot.value;
      setState(() {
        red = _red.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Humidity :  $humidity",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "Cycle :  $cycle",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "FillBIN :  $fillBin %",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "LED GREEN :  $green",
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              "LED RED :  $red",
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
