import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'pagetwo.dart';
import 'pagethree.dart';
import 'pageone.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Splash(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SplashScreen(
        seconds: 4,
        navigateAfterSeconds: new MyHomePage(),
        title: new Text(
          'SMART BIN',
          textScaleFactor: 1.5,
        ),
        image: Image.asset('images/image1.png'),
        loadingText: Text("Loading"),
        photoSize: 100.0,
        loaderColor: Colors.black38,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
  ];
  final _database = FirebaseDatabase.instance.ref();
  String humidity = "Result go here";
  String temperature = "Result go here";
  String statuse = "Result go here";
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
        _database.child("/FirebaseIOT/statuse").onValue.listen((event) {
      final Object? _statuse = event.snapshot.value;
      setState(() {
        statuse = _statuse.toString();
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
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'SMART BIN',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: PageView.builder(
          itemCount: pages.length,
          itemBuilder: (context, position) => pages[position],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    _databaseSteam.cancel();
    super.deactivate();
  }
}
