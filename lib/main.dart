import 'package:flutter/material.dart';
import 'package:gymbro_app/pages/auth/auth_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: ThemeData(primaryColor: Colors.black, primarySwatch: Colors.blue, useMaterial3: true),
    );
  }
}
