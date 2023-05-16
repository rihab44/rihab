import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'page.dart';

class commande {
  String nomproduit;
  String typeprojet;
  int prixunitaire;
  String dateestime;
  int quantite;
  String nomutilisateur;
  int prix;

  commande(
    this.nomproduit,
    this.typeprojet,
    this.prixunitaire,
    this.dateestime,
    this.quantite,
    this.nomutilisateur,
    this.prix,
  );

  Map<String, dynamic> toJson() {
    return {
      'nomproduit': this.nomproduit,
      'typeprojet': this.typeprojet,
      'prixunitaire': this.prixunitaire,
      'dateestimé': this.dateestime,
      'quantité': this.quantite,
      'nomutilisateur': this.nomutilisateur,
      'prix': this.prix,
    };
  }
}

class productservice {
  static const String apiUrl = 'http://localhost:3000/addcommande';

  static Future<http.Response> addProduct(Map<String, dynamic> produit) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode(produit),
    );
    print("response");
    print(response);
    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Impossible d\'ajouter le produit');
    }
  }
}

class AddProductScreen extends StatefulWidget {
  final String nomProduitCommande;
  final String typeprojetCommande;
  final int prixproduit;

  AddProductScreen(
      {required this.nomProduitCommande,
      required this.typeprojetCommande,
      required this.prixproduit});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var _formKey = GlobalKey<FormState>();

  var _dateestimeController = TextEditingController();
  var _nomutilisateurController = TextEditingController();
  var _quantiteeController = TextEditingController();
  late int _prix;

  @override
  void initState() {
    super.initState();
    _prix = widget.prixproduit;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),
      appBar: AppBar(
        title: Text('commander'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Nom du produit :',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text(widget.nomProduitCommande,
                      style: TextStyle(fontSize: 18.0)),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text('Type de projet :',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text(widget.typeprojetCommande,
                      style: TextStyle(fontSize: 18.0)),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text('Prix unitaire :',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text('${widget.prixproduit} ',
                      style: TextStyle(fontSize: 18.0)),
                ],
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _nomutilisateurController,
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un nom d\'utilisateur';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _dateestimeController,
                decoration: InputDecoration(
                  labelText: 'la date estimée',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer la date estimée';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _quantiteeController,
                decoration: InputDecoration(
                  labelText: 'quantité',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer la quantité';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    var quantity = int.tryParse(value) ?? 0;
                    _prix = widget.prixproduit * quantity;
                  });
                },
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text('Prix :', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10.0),
                  Text('$_prix', style: TextStyle(fontSize: 18.0)),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 30.0,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 174, 45, 196),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var nomproduit = widget.nomProduitCommande;
                          var typeprojet = widget.typeprojetCommande;
                          var prixunitaire = widget.prixproduit;
                          var dateestime = _dateestimeController.text;
                          var nomutilisateur = _nomutilisateurController.text;
                          var quantite = int.parse(_quantiteeController.text);
                          var prix = _prix;
                          var productData = commande(
  nomproduit,
  typeprojet,
  prixunitaire,
  dateestime,
  quantite,
  nomutilisateur,
  prix,
).toJson();
print('Product data: $productData');
var success = productservice.addProduct(productData);


                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => page1()),
                          );
                        }
                      },
                      child: Text('ajouter'))),
            ],
          ),
        ),
      ),
    );
  }
}
