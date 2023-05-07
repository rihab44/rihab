import 'package:flutter/material.dart';
import 'cabletrace.dart';
import 'accessoiretrace.dart';

class trace1 extends StatefulWidget {
  @override
  State<trace1> createState() => _trace1State();
}

class _trace1State extends State<trace1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 246, 243, 247),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.purple,
            title: Text('traçabilité des produits',
                style: TextStyle(
                  color: Color.fromARGB(255, 254, 251, 251),
                  fontSize: 30,
                ))),
        body: Container(
            padding: EdgeInsets.all(30.0),
            child: GridView.count(crossAxisCount: 1, children: <Widget>[
              Card(
                margin: EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => cableproduct1()),
                    );
                  },
                  splashColor: Colors.purple,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.source,
                          size: 40.0,
                          color: Colors.deepPurple,
                        ),
                        Text(
                          "les cables ",
                          style: new TextStyle(fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => accessoireproduct1()),
                    );
                  },
                  splashColor: Colors.purple,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.source,
                          size: 40.0,
                          color: Colors.deepPurple,
                        ),
                        Text(
                          "  les accessoires ",
                          style: new TextStyle(fontSize: 14.0),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ])));
  }
}
