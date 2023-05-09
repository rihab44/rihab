import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'produit.dart';

class Produit {
  late String id;
  late String nom;
  late String categorie;
  late int prix;
  late int code;
  late int stockinitial;
  late int stocktompon;
  late int unitedemesure;

  Produit(
    this.id, {
    required this.nom,
    required this.categorie,
    required this.prix,
    required this.code,
    required this.stockinitial,
    required this.stocktompon,
    required this.unitedemesure,
  });

  Produit.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    nom = json['nom'];
    categorie = json['categorie'];
    prix = json['prix'];
    code = json['code'];
    stockinitial = json['stockinitial'];
    stocktompon = json['stocktompon'];
    unitedemesure = json['unitedemesure'];
  }
}

class APIService {
  Future<List<Produit>> getProduit() async {
    const String apiUrl = 'http://localhost:8000/products';
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      List<Produit> produits = [];
      for (var item in jsonData) {
        produits.add(Produit.fromJson(item));
      }
      return produits;
    } else {
      throw Exception('Impossible de récupérer les données.');
    }
  }

  Future<bool> deleteProduit(String id) async {
    bool status = false;
    var url = Uri.parse('http://localhost:8000/delete/$id');

    print('Sending delete request to $url');
    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print('Received delete response with status code ${response.statusCode}');
    if (response.statusCode == 200) {
      status = response.body.isNotEmpty;
    }
    return status;
  }
}

Future<bool> updateProduit(Map<String, dynamic> Produit, String id) async {
  bool status = false;
  var url = Uri.parse('http://localhost:8000/update/$id');

  print('Sending update request to $url with data $Produit');
  var response = await http.post(
    url,
    body: jsonEncode(Produit),
    headers: {
      'Content-Type': 'application/json',
    },
  );
  print('Received update response with status code ${response.statusCode}');
  if (response.statusCode == 200) {
    status = response.body.isNotEmpty;
  }
  return status;
}

class ProduitListView extends StatefulWidget {
  @override
  _ProduitListViewState createState() => _ProduitListViewState();
}

class _ProduitListViewState extends State<ProduitListView> {
  late Future<List<Produit>> _produitsFuture;

  @override
  void initState() {
    super.initState();
    _produitsFuture = APIService().getProduit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        title: Text("Liste des produits"),
      ),
      body: FutureBuilder<List<Produit>>(
        future: _produitsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Produit>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Produit produit = snapshot.data![index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            produit.nom,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text("Catégorie: ${produit.categorie}"),
                          SizedBox(height: 8),
                          Text("Prix: ${produit.prix}"),
                          SizedBox(height: 8),
                          Text("Code: ${produit.code}"),
                          SizedBox(height: 8),
                          Text("Stock initial: ${produit.stockinitial}"),
                          SizedBox(height: 8),
                          Text("Stock tampon: ${produit.stocktompon}"),
                          SizedBox(height: 8),
                          Text("Unité de mesure: ${produit.unitedemesure}"),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.purple,
                                ),
                                child: Text('Modifier'),
                                onPressed: () {
                                  editUserDialog(produit);
                                },
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                child: Text('Supprimer'),
                                onPressed: () async {
                                  bool status = await APIService()
                                      .deleteProduit(produit.id);
                                  print('Delete status: $status');
                                  if (status) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Produit supprimé')),
                                    );
                                    setState(() {
                                      _produitsFuture =
                                          APIService().getProduit();
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Impossible de supprimer le produit')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  void editUserDialog(Produit produit) {
    TextEditingController nomController =
        TextEditingController(text: produit.nom);
    TextEditingController categorieController =
        TextEditingController(text: produit.categorie);
    TextEditingController codeController =
        TextEditingController(text: produit.code.toString());
    TextEditingController prixController =
        TextEditingController(text: produit.prix.toString());
    TextEditingController stockinitialController =
        TextEditingController(text: produit.stockinitial.toString());
    TextEditingController stocktomponController =
        TextEditingController(text: produit.stocktompon.toString());
    TextEditingController unitedemesureController =
        TextEditingController(text: produit.unitedemesure.toString());
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Modifier le produit'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(hintText: 'Nom'),
                ),
                TextField(
                  controller: categorieController,
                  decoration: InputDecoration(hintText: 'categorie'),
                ),
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(hintText: 'code'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: prixController,
                  decoration: InputDecoration(hintText: 'prix'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stockinitialController,
                  decoration: InputDecoration(hintText: 'stock initial'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stocktomponController,
                  decoration: InputDecoration(hintText: 'stock tompon'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: unitedemesureController,
                  decoration: InputDecoration(hintText: 'unité de mesure'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: <Widget>[
              
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 174, 45, 196),
                ),
                child: Text('Annuler'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 174, 45, 196),
                ),
                child: Text('Modifier'),
                onPressed: () async {
                  Map<String, dynamic> produitToUpdate = {
                    'nom': nomController.text,
                    'categorie': categorieController.text,
                    'code': int.parse(codeController.text),
                    'prix': int.parse(prixController.text),
                    'stockinital': int.parse(stockinitialController.text),
                    'stocktompon': int.parse(stocktomponController.text),
                    'unitédemesure': int.parse(unitedemesureController.text),
                  };
                  bool status =
                      await updateProduit(produitToUpdate, produit.id);
                  print('Update status: $status');
                  if (status) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('produit modifié')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Impossible de mettre à jour le produit')));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
