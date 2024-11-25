import 'package:flutter/material.dart';
import 'database_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    try {
      await DatabaseHelper().insertUser(username, email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User registered successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Color(0xFF8B0000), // Rojo ladrillo
      ),
      backgroundColor: Color(0xFF1C1C1C), // Fondo negro carbón
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Color(0xFF8B0000)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email, color: Color(0xFF8B0000)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: Color(0xFF8B0000)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF4500), // Rojo fuego
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Register",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
