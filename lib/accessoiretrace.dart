import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ajouttrace.dart';

class accessoire {
  late String nom;
  late String categorie;
  late int prix;
  late int code;
  late int stockinitial;
  late int stocktompon;
  late int? unitedemesure;
  bool selected = false;

  accessoire({
    required this.nom,
    required this.categorie,
    required this.prix,
    required this.code,
    required this.stockinitial,
    required this.stocktompon,
    required this.unitedemesure,
  });

  accessoire.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    categorie = json['categorie'];
    prix = json['prix'];
    code = json['code'];
    stockinitial = json['stockinitial'];
    stocktompon = json['stocktompon'];
    unitedemesure =
        json['unitedemesure'] != null ? json['unitedemesure'] as int : 0;
  }
}

class accessoireproduct1 extends StatefulWidget {
  const accessoireproduct1({Key, key}) : super(key: key);

  @override
  State<accessoireproduct1> createState() => _accessoireproduct1State();
}

class _accessoireproduct1State extends State<accessoireproduct1> {
  List<accessoire>? accessoires;
  List<accessoire> _selectedaccessoires = [];

  void _onaccessoireSelected(accessoire accessoires) {
    setState(() {
      accessoires.selected = !accessoires.selected;
      if (accessoires.selected) {
        _selectedaccessoires.add(accessoires);
      } else {
        _selectedaccessoires.remove(accessoires);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchaccessoires().then((value) {
      setState(() {
        accessoires = value;
      });
    });
  }

  Future<List<accessoire>> fetchaccessoires() async {
    const String apiUrl = 'http://localhost:8000/accessoire';
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var accessoiresJson = json.decode(response.body);
      if (accessoiresJson is List) {
        // vérifier que cablesJson est une liste
        List<accessoire> accessoires = accessoiresJson
            .map((accessoireJson) => accessoire.fromJson(accessoireJson))
            .toList();
        return accessoires;
      }
    }

    return [];
  }

  void _onCommanderPressed() {
    if (_selectedaccessoires.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ajouttrace(
                  nomProduitCommande: _selectedaccessoires[0].nom,
                )),
      );
    } else {
      // Afficher un message d'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        title: Text(
          'ajout commande',
          style: TextStyle(
            color: Color.fromARGB(255, 254, 251, 251),
            fontSize: 30,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(accessoires?[index].nom ?? ""),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        );
                      });
                  _onaccessoireSelected(accessoires![index]);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 32.0, bottom: 32.0, left: 16.0),
                  child: Row(
                    children: [
                      Checkbox(
                        value: accessoires![index].selected,
                        onChanged: (bool? value) {
                          _onaccessoireSelected(accessoires![index]);
                        },
                      ),
                      Expanded(
                        child: Text(
                          accessoires![index].nom,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ));
        },
        itemCount: accessoires?.length ?? 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCommanderPressed,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
