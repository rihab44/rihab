import 'dart:convert';
import 'package:http/http.dart' as http;
import 'page.dart';

import 'package:flutter/material.dart';

class user {
  String nom;
  String email;
  double numero;
  String password;

  user(this.nom, this.email, this.numero, this.password);
  Map<String, dynamic> toJson() {
    return {
      'nom': this.nom,
      'email': this.email,
      'numero': this.numero,
      'password': this.password,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),

        appBar: AppBar(
          title: Text('ajout utulisateur'),
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
                    decoration: InputDecoration(labelText: 'nom'),
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
                    decoration: InputDecoration(labelText: 'Numéro'),
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
                    decoration: InputDecoration(labelText: 'motdepasse'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'donner mot de passe  utulisateur';
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
                          var success = UserService.adduser(
                              user(nom, email, numero, password).toJson());
                          print(jsonEncode(
                              user(nom, email, numero, password).toJson()));
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
