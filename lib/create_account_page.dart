import 'package:flutter/material.dart';
import 'database_helper.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _createAccount() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      await DatabaseHelper().insertUser(email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C), // Fondo negro carbón
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000), // Rojo ladrillo
        title: Text(
          "Create Account",
          style: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo de texto para nombre de usuario
              TextField(
                controller: _usernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "User Name",
                  labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person, color: Color(0xFF8B0000)), // Rojo ladrillo
                ),
              ),
              SizedBox(height: 16),

              // Campo de texto para email
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF8B0000)), // Rojo ladrillo
                ),
              ),
              SizedBox(height: 16),

              // Campo de texto para contraseña
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF8B0000)), // Rojo ladrillo
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),

              // Campo de texto para confirmar contraseña
              TextField(
                controller: _confirmPasswordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF8B0000)), // Rojo ladrillo
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),

              // Botón para crear cuenta
              ElevatedButton(
                onPressed: _createAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B0000), // Rojo ladrillo
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Create Account",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
