import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Future<Map<String, dynamic>> _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = _fetchUserProfile();
  }

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    final response = await http.get(Uri.parse('http://localhost:3000/user/645fa2714c0aa6a190fbc26b')); // Remplacez "your-backend-api" par l'URL de votre API backend et "123" par l'ID de l'utilisateur

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 240, 244),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        title: Text('Profil'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final userProfile = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.purple,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Nom de l\'utilisateur: ${userProfile['nom']}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Numéro de téléphone: ${userProfile['numero']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'Adresse e-mail: ${userProfile['email']}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
               
 
                Text(
                  'Mot de passe:',
                  style: TextStyle(fontSize: 18),
                ),
                
                 TextField(
                  enabled: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: '••••••••••',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
  
              ],
            );
          }
        },
      ),
    );
  }
}
