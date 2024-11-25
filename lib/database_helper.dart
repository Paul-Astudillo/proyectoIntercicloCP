import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  final String baseUrl = 'http://192.168.8.102:8000'; // Cambia según tu backend

  // Función para registrar un usuario
  Future<void> insertUser(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/usuarios/'), // Endpoint para registrar usuarios
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username, // Nombre de usuario
          'email': email, // Email del usuario
          'password': password, // Contraseña
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to register user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  // Función para validar un usuario (login)
  Future<bool> validateUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/login/'), // Endpoint para login
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username, // Nombre de usuario
          'password': password, // Contraseña
        }),
      );

      if (response.statusCode == 200) {
        return true; // Credenciales válidas
      } else {
        throw Exception('Invalid credentials: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }
}
