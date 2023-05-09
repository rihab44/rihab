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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        title: Text(
          'Traçabilité des produits',
          style: TextStyle(
            color: Color.fromARGB(255, 254, 251, 251),
            fontSize: 30,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),

          crossAxisCount: 1, // 1 colonne pour une disposition en dessous
          childAspectRatio: 2, // rapport largeur-hauteur pour chaque élément
          
          children: <Widget>[
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
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
                        "Les câbles",
                        style: TextStyle(fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
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
                        "Les accessoires",
                        style: TextStyle(fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
