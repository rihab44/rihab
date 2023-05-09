import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1a/ajoututulisateur.dart';
import 'package:http/http.dart' as http;

class User {
  late String id;
  late String nom;
  late String email;
  late int numero;

  User(
    this.id, {
    required this.nom,
    required this.email,
    required this.numero,
  });
  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    nom = json['nom'];
    email = json['email'];
    numero = json['numero'];
  }
}

class APIService1 {
  Future<List<User>> getuser() async {
    const String apiUrl = 'http://localhost:3000/getinfo';
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
      List<User> users = [];
      for (var item in jsonData) {
        users.add(User.fromJson(item));
      }
      return users;
    } else {
      throw Exception('Impossible de récupérer les données.');
    }
  }

  Future<bool> deleteUser(String id) async {
    bool status = false;
    var url = Uri.parse('http://localhost:3000/delete/$id');

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

Future<bool> updateUser(Map<String, dynamic> User, String id) async {
  bool status = false;
  var url = Uri.parse('http://localhost:3000/update/$id');

  print('Sending update request to $url with data $User');
  var response = await http.post(
    url,
    body: jsonEncode(User),
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

class MyDataTable1 extends StatefulWidget {
  @override
  _MyDataTable1State createState() => _MyDataTable1State();
}

class _MyDataTable1State extends State<MyDataTable1> {
  late Future<List<User>> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = APIService1().getuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        title: Text("liste des utilisateurs"),
      ),
      body: FutureBuilder<List<User>>(
          future: _userFuture,
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    User user = snapshot.data![index];
                    return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nom et prénom : ${user.nom}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text("Numero de téléphone : ${user.numero}"),
                                  SizedBox(height: 8),
                                  Text("Email: ${user.email}"),
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
                                            editUserDialog(user);
                                          },
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.red,
                                          ),
                                          child: Text('Supprimer'),
                                          onPressed: () async {
                                            bool status = await APIService1()
                                                .deleteUser(user.id);
                                            print('Delete status: $status');
                                            if (status) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content:
                                                        Text('utilisateur supprimé')),
                                              );
                                              setState(() {
                                                _userFuture =
                                                    APIService1().getuser();
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Impossible de supprimer utilisateur')),
                                              );
                                            }
                                          },
                                        ),
                                      ])
                                ])));
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ajout()),
          );
        },
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }

  void editUserDialog(User user) {
    TextEditingController nomController = TextEditingController(text: user.nom);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController numeroController =
        TextEditingController(text: user.numero.toString());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Modifier l\'utilisateur'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(hintText: 'Nom'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                TextField(
                  controller: numeroController,
                  decoration: InputDecoration(hintText: 'Numéro'),
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
                  Map<String, dynamic> userToUpdate = {
                    'nom': nomController.text,
                    'email': emailController.text,
                    'numero': int.parse(numeroController.text),
                  };
                  bool status = await updateUser(userToUpdate, user.id);
                  print('Update status: $status');
                  if (status) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Utilisateur mis à jour')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Impossible de mettre à jour l\'utilisateur')));
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
