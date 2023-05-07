import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class commande {
  late String id;
  late String nomproduit;
  late String typeprojet;
  late int prixunitaire;
  late String dateestime;
  late int quantite;
  late String nomutilisateur;
  late int prix;

  commande(
    this.id, {
    required this.nomproduit,
    required this.typeprojet,
    required this.prixunitaire,
    required this.dateestime,
    required this.quantite,
    required this.nomutilisateur,
    required this.prix,
  });
  commande.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    nomproduit = json['nomproduit'];
    typeprojet = json['typeprojet'];
    prixunitaire = json['prixunitaire'];
    dateestime = json['dateestimé'];
    quantite = json['quantité'];
    nomutilisateur = json['nomutilisateur'];
    prix = json['prix'];
  }
}

class APIService11 {
  Future<List<commande>> getcommande() async {
    const String apiUrl = 'http://localhost:3000/getcommande';
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
      List<commande> commandes = [];
      for (var item in jsonData) {
        commandes.add(commande.fromJson(item));
      }
      return commandes;
    } else {
      throw Exception('Impossible de récupérer les données.');
    }
  }

  Future<bool> deletecommande(String id) async {
    bool status = false;
    var url = Uri.parse('http://localhost:3000/deletecommande/$id');

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

Future<bool> updatecommande(Map<String, dynamic> commande, String id) async {
  bool status = false;
  var url = Uri.parse('http://localhost:3000/updatecommande/$id');

  print('Sending update request to $url with data $commande');
  var response = await http.post(
    url,
    body: jsonEncode(commande),
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

class ListCommande extends StatefulWidget {
  @override
  State<ListCommande> createState() => _ListCommandeState();
}

class _ListCommandeState extends State<ListCommande> {
  late Future<List<commande>> _commandesFuture;
  int _totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _commandesFuture = APIService11().getcommande();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        title: Text("Liste des commandes"),
      ),
      body: FutureBuilder<List<commande>>(
        future: _commandesFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<commande>> snapshot) {
          if (snapshot.hasData) {
            _totalPrice = 0;
            snapshot.data!.forEach((commande) {
              _totalPrice += commande.prix;
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      commande Commande = snapshot.data![index];

                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nom du produit: ${Commande.nomproduit}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Type de projet: ${Commande.typeprojet}'),
                              SizedBox(height: 8),
                              Text('Prix unitaire: ${Commande.prixunitaire}'),
                              SizedBox(height: 8),
                              Text('Date estimée: ${Commande.dateestime}'),
                              SizedBox(height: 8),
                              Text(
                                  'Nom d\'utilisateur: ${Commande.nomutilisateur}'),
                              SizedBox(height: 8),
                              Text('Prix: ${Commande.prix}'),
                              SizedBox(height: 8),
                              Text('Quantité: ${Commande.quantite}'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.purple,
                                    ),
                                    child: Text('Modifier'),
                                    onPressed: () {
                                      editcommadeDialog(Commande);
                                    },
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Text('Supprimer'),
                                    onPressed: () async {
                                      bool status = await APIService11()
                                          .deletecommande(Commande.id);
                                      print('Delete status: $status');
                                      if (status) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('Produit supprimé')),
                                        );
                                        setState(() {
                                          _commandesFuture =
                                              APIService11().getcommande();
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'prix totale: $_totalPrice',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void editcommadeDialog(commande Commande) {
    TextEditingController nomproduitController =
        TextEditingController(text: Commande.nomproduit);
    TextEditingController typeprojetController =
        TextEditingController(text: Commande.typeprojet);
    TextEditingController prixunitaireController =
        TextEditingController(text: Commande.prixunitaire.toString());
    TextEditingController nomutilisateurController =
        TextEditingController(text: Commande.nomutilisateur);
    TextEditingController dateestimeeController =
        TextEditingController(text: Commande.dateestime);
    TextEditingController quatiteController =
        TextEditingController(text: Commande.quantite.toString());
    TextEditingController prixController =
        TextEditingController(text: Commande.prix.toString());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Modifier la commande'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nomproduitController,
                  decoration: InputDecoration(hintText: 'Nom du produit'),
                ),
                TextField(
                  controller: typeprojetController,
                  decoration: InputDecoration(hintText: 'type de projet'),
                ),
                TextField(
                  controller: prixunitaireController,
                  decoration: InputDecoration(hintText: 'prix unitaire'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: nomutilisateurController,
                  decoration: InputDecoration(hintText: 'nom utilisateur'),
                ),
                TextField(
                  controller: dateestimeeController,
                  decoration: InputDecoration(hintText: 'la date estimée'),
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
                  Map<String, dynamic> userToUpdate = {
                    'nomproduit': nomproduitController.text,
                    'typeprojet': typeprojetController.text,
                    'prixunitaire': int.parse(prixunitaireController.text),
                    'quantité': int.parse(quatiteController.text),
                    'prix': int.parse(prixController.text),
                    'nomputilisateur': nomutilisateurController.text,
                    'dateestimee': dateestimeeController.text,
                  };
                  bool status = await updatecommande(userToUpdate, Commande.id);
                  print('Update status: $status');
                  if (status) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('commande mis à jour')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Impossible de mettre à jour la commande')));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
