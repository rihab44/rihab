import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ajouttrace.dart';

class cable {
  late String nom;
  late String categorie;
  late int prix;
  late int code;
  late int stockinitial;
  late int stocktompon;
  late int? unitedemesure;
  bool selected = false;

  cable({
    required this.nom,
    required this.categorie,
    required this.prix,
    required this.code,
    required this.stockinitial,
    required this.stocktompon,
    required this.unitedemesure,
  });

  cable.fromJson(Map<String, dynamic> json) {
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

class cableproduct1 extends StatefulWidget {
  const cableproduct1({Key? key}) : super(key: key);

  @override
  State<cableproduct1> createState() => _cableproduct1State();
}

class _cableproduct1State extends State<cableproduct1> {
  List<cable>? cables;
  List<cable> _selectedcables = [];

  void _oncableSelected(cable cables) {
    setState(() {
      cables.selected = !cables.selected;
      if (cables.selected) {
        _selectedcables.add(cables);
      } else {
        _selectedcables.remove(cables);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchcables().then((value) {
      setState(() {
        cables = value;
      });
    });
  }

  Future<List<cable>> fetchcables() async {
    const String apiUrl = 'http://localhost:8000/cable';
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var cablesJson = json.decode(response.body);
      if (cablesJson is List) {
        // vérifier que cablesJson est une liste
        List<cable> cables =
            cablesJson.map((cableJson) => cable.fromJson(cableJson)).toList();
        return cables;
      }
    }

    return [];
  }

  void _onCommanderPressed() {
    if (_selectedcables.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ajouttrace(
                  nomProduitCommande: _selectedcables[0].nom,
                )),
      );
    } else {
      // Afficher un message d'erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple,
        title: Text(
          'traçabilité du produit',
          style: TextStyle(
            color: Colors.white,
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
                      title: Text(cables?[index].nom ?? ""),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    );
                  },
                );
                _oncableSelected(cables![index]);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Checkbox(
                      value: cables![index].selected,
                      onChanged: (bool? value) {
                        _oncableSelected(cables![index]);
                      },
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        cables![index].nom,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: cables?.length ?? 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCommanderPressed,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}
