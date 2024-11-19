import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart'; // Una nueva clase para la pantalla principal

void main() {
  runApp(const InstagramClone());
}

class InstagramClone extends StatefulWidget {
  const InstagramClone({Key? key}) : super(key: key);

  @override
  _InstagramCloneState createState() => _InstagramCloneState();
}

class _InstagramCloneState extends State<InstagramClone> {
  bool isAuthenticated = false;

  void _loginSuccess() {
    setState(() {
      isAuthenticated = true;
    });
  }

  void _logout() {
    setState(() {
      isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixion',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isAuthenticated
          ? HomePage(onLogout: _logout) // Pantalla principal con cierre de sesión
          : LoginPage(onLoginSuccess: _loginSuccess), // Pantalla de login
    );
  }
}
