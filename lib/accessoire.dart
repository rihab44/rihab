import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'formulecommande.dart';

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

class accessoireproduct extends StatefulWidget {
  const accessoireproduct({Key, key}) : super(key: key);

  @override
  State<accessoireproduct> createState() => _accessoireproductState();
}

class _accessoireproductState extends State<accessoireproduct> {
  List<accessoire>? accessoires;
  List<accessoire> _selectedaccessoires = [];
  late int prixselectionne;

  List<String> typesDeProjets = [
    'grand projet',
    'MCT2 extention partielle',
    'construction',
    'amenagement SWAP'
  ];
  String? typeDeProjetSelectionne;


 void _onaccessoireSelected(accessoire accessoires) {
  setState(() {
    accessoires.selected = !accessoires.selected;
    if (accessoires.selected) {
      _selectedaccessoires.add(accessoires);
      prixselectionne = accessoires.prix; // stocker le prix de l'accessoire sélectionné
    } else {
      _selectedaccessoires.remove(accessoires);
      prixselectionne = 0; // effacer le prix si l'accessoire est désélectionné
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
    DropdownButtonFormField<String>(
      value: typeDeProjetSelectionne,
      onChanged: (value) {
        setState(() {
          typeDeProjetSelectionne = value;
        });
      },
      items: typesDeProjets.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Type de projet',
        border: OutlineInputBorder(),
      ),
    );
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
      typeprojetDialog();
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
                        children: [
                          Text(
                              'stock initial:${accessoires?[index].stockinitial ?? ""}',
                              style: TextStyle(fontSize: 16),
                              ),
                          Text(
                              'stock tompon:${accessoires?[index].stocktompon ?? ""}',
                              style: TextStyle(fontSize: 16),
                              ),
                          Text('prix:${accessoires?[index].prix ?? ""}'
                                                 ,style: TextStyle(fontSize: 16),
                                                 ),

                        ],
                      ),
                    );
                  });
              _onaccessoireSelected(accessoires![index]);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0),
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
    child: Icon(Icons.shopping_cart),
  ),
    );
  }
  void typeprojetDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Sélectionner le type de projet"),
        content: DropdownButtonFormField<String>(
          value: typeDeProjetSelectionne,
          onChanged: (value) {
            setState(() {
              typeDeProjetSelectionne = value;
              Navigator.pop(context); // ferme la boîte de dialogue
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductScreen(
                   nomProduitCommande: _selectedaccessoires[0].nom,
            typeprojetCommande: typeDeProjetSelectionne!,
                                prixproduit: prixselectionne, // transmettre le prix sélectionné

                  ),
                ),
              );

            });
          },
          items: typesDeProjets.map((type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          decoration: InputDecoration(
            labelText: 'Type de projet',
            border: OutlineInputBorder(),
          ),
        ),
      );
    },
  );
}

}