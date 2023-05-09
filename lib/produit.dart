import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'page.dart';

class Produit {
  String nom;
  String categorie;
  double prix;
  double code;
  double stockinitial;
  double stocktompon;
  double unitedemesure;

  Produit(this.nom, this.categorie, this.prix, this.code, this.stockinitial, this.stocktompon,
      this.unitedemesure);
  Map<String, dynamic> toJson() {
    return {
      'nom': this.nom,
      'categorie': this.categorie,
      'prix': this.prix,
      'code': this.code,
      'stockinitial': this.stockinitial,
      'stocktompon' : this.stocktompon,
      'unitedemesure': this.unitedemesure,
    };
  }
}

class productservice {
  static const String apiUrl = 'http://localhost:8000/addproduct';

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
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var _formKey = GlobalKey<FormState>();
  var _nomController = TextEditingController();
  var _categorieController = TextEditingController();

  var _prixController = TextEditingController();
  var _codeController = TextEditingController();
  var _stockinitialController = TextEditingController();
    var _stocktomponController = TextEditingController();

  var _unitedemesureController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),

      appBar: AppBar(
        title: Text('ajoutper un roduit'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'nom',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner le nom du produit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _categorieController,
                decoration: InputDecoration(
                  labelText: 'categorie',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner le type du produit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _prixController,
                decoration: InputDecoration(
                  labelText: 'prix',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner le prix du produit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'code',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner le code du produit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _stockinitialController,
                decoration: InputDecoration(
                  labelText: 'stock initial',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner le nombre de stock initial du produit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
               TextFormField(
                controller: _stocktomponController,
                decoration: InputDecoration(
                  labelText: 'stock tompon',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner le nombre de stock tompon du produit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _unitedemesureController,
                decoration: InputDecoration(
                  labelText: ' unite de mesure',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner l"unite de mesure du produit';
                  }
                  return null;
                },
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
                          var nom = _nomController.text;
                          var categorie = _categorieController.text;
                          var prix = double.parse(_prixController.text);
                          var code = double.parse(_codeController.text);
                          var stockinitial = double.parse(_stockinitialController.text);
                           var stocktompon = double.parse(_stocktomponController.text);
                          var unitedemesure =
                              double.parse(_unitedemesureController.text);
                          var success = productservice.addProduct(Produit(
                                  nom, categorie, prix, code, stockinitial, stocktompon , unitedemesure)
                              .toJson());
                          print(jsonEncode(Produit(
                                  nom, categorie, prix, code, stockinitial,stocktompon, unitedemesure)
                              .toJson()));

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
