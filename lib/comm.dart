import 'package:flutter/material.dart';
import 'cable.dart';
import 'accessoire.dart';

class commande1 extends StatefulWidget {
  const commande1({super.key});

  @override
  State<commande1> createState() => _commande1State();
}

class _commande1State extends State<commande1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        title: Text(
          'Ajouter une commande',
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
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
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
                    MaterialPageRoute(builder: (context) => cableproduct()),
                  );
                },
                splashColor: Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.source,
                      size: 60.0,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Les câbles',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => accessoireproduct()),
                  );
                },
                splashColor: Colors.purple,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.source,
                      size: 60.0,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Les accessoires',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
