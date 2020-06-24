import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;
import 'package:wisdom_quotes/pages/shake.dart';
import 'package:localstorage/localstorage.dart';

class WisdonQuoteList extends StatefulWidget {
  static const String id = "wisdom_quotes_list";

  @override
  _WisdonQuoteListState createState() => _WisdonQuoteListState();
}

class _WisdonQuoteListState extends State<WisdonQuoteList> {
  final LocalStorage storage = new LocalStorage('wisdom_quotes');
  List jsonData = [];
  bool isLoading = false;

  void getList() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      List datas = [];
      Http.Response response;
      try {
        response = await Http.get(
          'https://script.google.com/macros/s/AKfycby84EGb7ERKVocCvAq-SQ1fvQmrsg5Ob6jGpm9RoIWfMGzCVO4/exec?id=1BKRiDGf5DQ5FVL8VO4xI_i5dzZ5wWt5XIY5pySe4Msk',
        );

        if (response.statusCode == 200) {
          datas = jsonDecode(response.body)['data'];

          await storage.ready;
          storage.setItem('data', datas);
        }
      } catch (e) {
        print(e);
      }

      if (datas.length == 0) {
        await storage.ready;
        List storageData = storage.getItem('data');
        if (storageData != null) {
          datas = storageData;
        }
      }

      print(datas);

      setState(() {
        jsonData = datas;
        isLoading = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text('Wisdom Quotes'),
            ),
            IconButton(
              icon: Icon(Icons.open_in_new),
              onPressed: () {
                Navigator.pushNamed(context, WisdonQuoteShake.id);
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: jsonData.length,
          itemBuilder: (BuildContext context, int index) {
            if (jsonData.length == 0) {
              return _buildProgressIndicator();
            } else {
              return Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${jsonData[index]['source']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        '${jsonData[index]['chinese']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '${jsonData[index]['english']}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
