import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

class APIService4 {
  Future<User> getprofile(String id) async {
    String apiUrl = 'http://localhost:3000/$id';
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
      User user = User.fromJson(jsonData);
      return user;
    } else {
      throw Exception('Impossible de récupérer les données.');
    }
  }
}

class ProfilePage extends StatefulWidget {
  ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      var apiService = APIService4();
      var user = await apiService.getprofile(userId!);
      setState(() {
        this.user = user;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profil utilisateur'),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nom utilisateur: ${user!.nom}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text("Numero de téléphone : ${user!.numero}"),
                SizedBox(height: 8),
                Text("Email: ${user!.email}"),
              ],
            ),
          ),
        ),
      );
    }
  }
}
