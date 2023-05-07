import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'page.dart';

class trace {
  String nomproduit;
  String ordreservice;
  String adressedetraveaux;
  String nomentreprise;
  double numerodemarche;
  String augentdesuivie;

  trace(
    this.nomproduit,
    this.ordreservice,
    this.adressedetraveaux,
    this.nomentreprise,
    this.numerodemarche,
    this.augentdesuivie,
  );
  Map<String, dynamic> toJson() {
    return {
      'nomproduit': this.nomproduit,
      'ordreservice': this.ordreservice,
      'adressedetraveaux': this.adressedetraveaux,
      'nomentreprise': this.nomentreprise,
      'numerodemarche': this.numerodemarche,
      'augentdesuivie': this.augentdesuivie,
    };
  }
}

class service {
  static const String apiUrl = 'http://localhost:3000/addtrace';

  static Future<http.Response> addtrace(Map<String, dynamic> trace) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode(trace),
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

class ajouttrace extends StatefulWidget {
  final String nomProduitCommande;

  ajouttrace({
    required this.nomProduitCommande,
  });
  @override
  State<ajouttrace> createState() => _ajouttraceState();
}

class _ajouttraceState extends State<ajouttrace> {
  var _formKey = GlobalKey<FormState>();
  var _nomproduitController = TextEditingController();
  var _ordreserviceController = TextEditingController();

  var _adressedetraveauxController = TextEditingController();
  var _nomentrepriseController = TextEditingController();
  var _numerodemarcheController = TextEditingController();
  var _augentdesuivieController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        title: Text("traçabilité des produits"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Nom du produit :',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 10.0),
              Text(widget.nomProduitCommande, style: TextStyle(fontSize: 18.0)),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _ordreserviceController,
                decoration: InputDecoration(
                  labelText: 'ordre service',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner ordre service du produit';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _adressedetraveauxController,
                decoration: InputDecoration(
                  labelText: 'adresse de traveaux',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner adresse de traveaux';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _nomentrepriseController,
                decoration: InputDecoration(
                  labelText: 'nom entreprise',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner le nom de entreprise';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _numerodemarcheController,
                decoration: InputDecoration(
                  labelText: 'numero de marche ',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner le numero de marche';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _augentdesuivieController,
                decoration: InputDecoration(
                  labelText: 'augent de suivie',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'donner augent de suivie';
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
                          var nomproduit = _nomproduitController.text;
                          var ordreservice = _ordreserviceController.text;
                          var adressedetraveaux =
                              _adressedetraveauxController.text;
                          var nomentreprise = _nomentrepriseController.text;
                          var numerodemarche =
                              double.parse(_numerodemarcheController.text);
                          var augentdesuivie = _augentdesuivieController.text;
                          var success = service.addtrace(trace(
                            nomproduit,
                            ordreservice,
                            adressedetraveaux,
                            nomentreprise,
                            numerodemarche,
                            augentdesuivie,
                          ).toJson());
                          print(jsonEncode(trace(
                                  nomproduit,
                                  ordreservice,
                                  adressedetraveaux,
                                  nomentreprise,
                                  numerodemarche,
                                  augentdesuivie)
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
