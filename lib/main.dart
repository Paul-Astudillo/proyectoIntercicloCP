import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

void main() {
  runApp(const InstagramClone());
}

class InstagramClone extends StatelessWidget {
  const InstagramClone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pixion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AuthenticationManager(),
    );
  }
}

class AuthenticationManager extends StatefulWidget {
  const AuthenticationManager({Key? key}) : super(key: key);

  @override
  _AuthenticationManagerState createState() => _AuthenticationManagerState();
}

class _AuthenticationManagerState extends State<AuthenticationManager> {
  bool isAuthenticated = false;

  void _handleLoginSuccess() {
    setState(() {
      isAuthenticated = true;
    });
  }

  void _handleLogout() {
    setState(() {
      isAuthenticated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isAuthenticated
        ? HomePage(onLogout: _handleLogout) // Pantalla principal
        : LoginPage(onLoginSuccess: _handleLoginSuccess); // Pantalla de login
  }
}
