import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_firebase/HistoryPage.dart';
import 'dart:math';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test 2',
      routes: {
        '/history': (context) => HistoryPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: Header(),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Random number generator"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new FirstScreen(),
      ),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Screen();
}

class Screen extends State<FirstScreen> {
  CollectionReference collectionReference = FirebaseFirestore.instance.collection('numbers');
  var random = new Random();
  final my_form_key = GlobalKey<FormState>();
  String textToShow = "";

  void GenerateRandomNumber() async {
    if (my_form_key.currentState.validate()) {
      int result = random.nextInt(1000);
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('MMMM dd, yyyy kk:mm').format(now);

      setState(() {
        textToShow = "$result";
      });
      await collectionReference.add({'randomNumber': textToShow, 'timestamp': formattedDate});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Form(
            key: my_form_key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  textToShow,
                  style: TextStyle(fontSize: 40.0),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: GenerateRandomNumber,
                        child: Text('Generate random number'),
                      ),
                    ]),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OutlineButton(
                          child: Text("Previous random numbers"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HistoryPage()),
                            );}
                      ),
                    ])
              ],
            )));
  }
}