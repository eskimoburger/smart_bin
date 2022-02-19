import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _database = FirebaseDatabase.instance.ref();
  String humidity = "Result go here";
  String temperature = "Result go here";
  late StreamSubscription _databaseSteam;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    _databaseSteam =
        _database.child("/FirebaseIOT/humidity").onValue.listen((event) {
      final Object? _humidity = event.snapshot.value;
      setState(() {
        humidity = _humidity.toString();
      });
    });
    _databaseSteam =
        _database.child("/FirebaseIOT/temperature").onValue.listen((event) {
      final Object? _temperature = event.snapshot.value;
      setState(() {
        temperature = _temperature.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = _database.child("test");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  try {
                    await data.set({'des': 'hello', 'price': 5.00});
                    print("Successfully!!");
                  } catch (e) {
                    print("Error : $e");
                  }
                },
                child: Text("Simple set")),
            Text("Humidity : $humidity"),
            Text("Temperature : $temperature"),
          ],
        ),
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void deactivate() {
    _databaseSteam.cancel();
    super.deactivate();
  }
}
