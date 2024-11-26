import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000), // Rojo ladrillo
        title: Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color(0xFF1C1C1C), // Fondo negro carbón
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo de la aplicación
              Center(
                child: Image.asset(
                  'assets/images/logo.png', // Cambia por la ruta real de tu logo
                  height: 120,
                  width: 120,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "About the App",
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "This app was created by:",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                "- Andrés Alvarado\n- Paul Astudillo\n- Diego Tapia",
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/ups.png', // Cambia por la ruta real de tu imagen
                height: 250, // Cambiado a dimensiones más pequeñas
                width: 250,
                fit: BoxFit.contain, // Cambiado a "contain" para mantener la proporción
              ),
              SizedBox(height: 20),
              Text(
                "All Rights Reserved © 2024",
                style: TextStyle(fontSize: 16, color: Colors.white, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                "Server IP: 192.168.1.5",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
