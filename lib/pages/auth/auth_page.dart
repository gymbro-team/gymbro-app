import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gymbro_app/core/constants.dart';
import 'package:gymbro_app/pages/workouts_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkTokenAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WorkoutsPage()),
      );
    }
  }

  void _login(String username, String password) async {
    try {
      var url = Uri.parse('$AUTH_URL/login');

      var response = await http.post(url,
          body: jsonEncode({
            'username': username,
            'password': password,
          }));

      if (response.statusCode == 200) {
        // Successful login
        // Parse response body to extract token
        String responseBody = response.body;
        // Assuming the token is a JSON field named 'token'
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        String token = jsonResponse['token'];

        // Save token to shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Navigate to home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WorkoutsPage()),
        );
      } else {
        print('Login failed');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Gymbro',
                style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                'Your personal gym trainer',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
              ),
              const SizedBox(height: 20),
              //TextFormField for username
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              //TextFormField for password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  // Perform login action
                  String username = _usernameController.text;
                  String password = _passwordController.text;

                  // Call your login API endpoint
                  _login(username, password);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(20.0),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Login'),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
