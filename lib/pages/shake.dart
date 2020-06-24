import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:math';

class WisdonQuoteShake extends StatefulWidget {
  static const String id = "wisdon_quote_shake";

  @override
  _WisdonQuoteShakeState createState() => _WisdonQuoteShakeState();
}

class _WisdonQuoteShakeState extends State<WisdonQuoteShake> {
  final LocalStorage storage = LocalStorage('wisdom_quotes');
  List jsonData = [];
  Words pickedData = Words(
    chinese: '請搖一搖您的手機',
    english: 'Please shake your phone',
    source: '',
  );

  void getData() async {
    await storage.ready;
    jsonData = await storage.getItem('data');
  }

  void pickWords() {
    var random = new Random();
    int index = random.nextInt(jsonData.length);
    setState(() {
      pickedData = Words(
        chinese: jsonData[index]['chinese'],
        english: jsonData[index]['english'],
        source: jsonData[index]['source'],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    ShakeDetector.autoStart(onPhoneShake: () {
      pickWords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick a word',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '${pickedData.source}',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black54,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              '${pickedData.chinese}',
              style: TextStyle(
                fontSize: 30.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              '${pickedData.english}',
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            RaisedButton(
              child: Text(
                'Pick',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                pickWords();
              },
            )
          ],
        ),
      ),
    );
  }
}

class Words {
  Words({this.chinese, this.english, this.source});

  final String chinese;
  final String english;
  final String source;
}
