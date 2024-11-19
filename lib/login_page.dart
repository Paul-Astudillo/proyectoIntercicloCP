import 'package:flutter/material.dart';
import 'database_helper.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final isValid = await DatabaseHelper().validateUser(email, password);

    if (isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login successful!")),
      );
      widget.onLoginSuccess(); // Notifica éxito al padre
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed!")),
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
          'Welcome to Social App',
          style: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),

              // Imagen centrada ligeramente a la derecha
              Align(
                alignment: Alignment.center, // Cambiado para mover la imagen a la izquierda
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                ),
              ),
              SizedBox(height: 30),

              // Título estilizado
              Text(
                "Log In",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF800020), // Rojo burdeos
                ),
              ),
              SizedBox(height: 20),

              // Campo de texto para email
              TextField(
                controller: _emailController,
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Gris claro
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF8B0000)), // Rojo ladrillo
                ),
              ),
              SizedBox(height: 20),

              // Campo de texto para contraseña
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), // Gris claro
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF8B0000)), // Rojo ladrillo
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // Botón de login estilizado
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF4500), // Rojo fuego
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),

              // Enlace para "Olvidé mi contraseña"
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Forgot Password? Not implemented!")),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Color(0xFFD3D3D3)), // Gris claro
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
