import 'dart:convert';
import 'package:http/http.dart' as http;
import 'page.dart';

import 'package:flutter/material.dart';

class user {
  String nom;
  String email;
  double numero;
  String password;
  String role;

  user(this.nom, this.email, this.numero, this.password, this.role);
  Map<String, dynamic> toJson() {
    return {
      'nom': this.nom,
      'email': this.email,
      'numero': this.numero,
      'password': this.password,
      'role': this.role,
    };
  }
}

class UserService {
  static const String apiUrl = 'http://localhost:3000/adduser';

  static Future<http.Response> adduser(Map<String, dynamic> user) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      body: jsonEncode(user),
    );
    print("response");
    print(response);
    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Impossible d\'ajouter utilisateur');
    }
  }
}

class ajout extends StatefulWidget {
  const ajout({Key? key}) : super(key: key);

  @override
  State<ajout> createState() => _ajoutState();
}

class _ajoutState extends State<ajout> {
  var _formKey = GlobalKey<FormState>();
  var _emailController = TextEditingController();

  var _nomController = TextEditingController();
  var _passwordController = TextEditingController();
  var _numeroController = TextEditingController();
  var _roleControlller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 243, 240, 244),
        appBar: AppBar(
          title: Text('ajouter un utulisateur'),
          backgroundColor: Color.fromARGB(255, 174, 45, 196),
          elevation: 0,
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _nomController,
                    decoration: InputDecoration(labelText: 'Nom et prénom'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'donner nom de utulisateur';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'donner email de utulisateur';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _numeroController,
                    decoration:
                        InputDecoration(labelText: 'Numéro de téléphone'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'donner numero de utulisateur';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'mot de passe'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'donner mot de passe  utulisateur';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _roleControlller,
                    decoration: InputDecoration(labelText: 'role'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'donner le role utulisateur';
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
                          var email = _emailController.text;
                          var numero = double.parse(_numeroController.text);
                          var password = _passwordController.text;
                          var role = _roleControlller.text;
                          var success = UserService.adduser(
                              user(nom, email, numero, password,role).toJson());
                          print(jsonEncode(
                              user(nom, email, numero, password,role).toJson()));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => page1()),
                          );
                        }
                      },
                      child: Text('ajouter'),
                    ),
                  ),
                ]))));
  }
}
