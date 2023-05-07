import 'package:flutter/material.dart';
import 'login.dart';
import 'produit.dart';
import 'ajoututulisateur.dart';
import 'produitliste.dart';
import 'listecommande.dart';
import 'listutilisateur.dart';
import 'comm.dart';
import 'admin.dart';
import 'traçeproduit.dart';

class page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 246, 243, 247),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.purple,
          title: Text('accueil',
              style: TextStyle(
                fontSize: 30,
              ))),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text('ajouter un utulisateur'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ajout()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('liste des utulisateurs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('deconnexion'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: GridView.count(crossAxisCount: 2, children: <Widget>[
          Card(
            margin: EdgeInsets.all(5.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProduitListView()),
                );
              },
              splashColor: Colors.purple,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.source,
                      size: 60.0,
                      color: Colors.deepPurple,
                    ),
                    Text(
                      "voir le stock ",
                      style: new TextStyle(fontSize: 17.0),
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
                  MaterialPageRoute(builder: (context) => commande1()),
                );
              },
              splashColor: Colors.purple,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.add_shopping_cart,
                      size: 60.0,
                      color: Colors.deepPurple,
                    ),
                    Text(
                      "  passer un commande ",
                      style: new TextStyle(fontSize: 17.0),
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
                  MaterialPageRoute(builder: (context) => traceproduit()),
                );
              },
              splashColor: Colors.purple,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.trending_up,
                      size: 60.0,
                      color: Colors.deepPurple,
                    ),
                    Text(
                      "voir la tracabilité des produitt ",
                      style: new TextStyle(fontSize: 17.0),
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
                  MaterialPageRoute(builder: (context) => ListCommande()),
                );
              },
              splashColor: Colors.purple,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.description,
                      size: 60.0,
                      color: Colors.deepPurple,
                    ),
                    Text(
                      "  liste des commandes ",
                      style: new TextStyle(fontSize: 17.0),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
