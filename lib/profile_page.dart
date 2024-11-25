import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String userEmail; // Email del usuario logueado para identificar sus imágenes.

  ProfilePage({required this.userEmail});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<dynamic> _userImages = []; // Lista para almacenar las imágenes desde el backend.
  bool _isLoading = true; // Estado para mostrar un indicador de carga.

  // Carga las imágenes del backend.
  Future<void> _loadUserImages() async {
    try {
      final response = await http.get(
        Uri.parse('http://your-backend-url/api/user-images?email=${widget.userEmail}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userImages = data['images']; // Se espera que el backend devuelva un array con las imágenes.
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading images: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserImages(); // Cargar las imágenes al iniciar la pantalla.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000), // Rojo ladrillo.
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Indicador de carga.
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Images: ${_userImages.length}", // Cantidad de imágenes.
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _userImages.length,
                    itemBuilder: (context, index) {
                      final image = _userImages[index];
                      return Card(
                        color: Colors.grey[900],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.network(
                                image['url'], // URL de la imagen desde el backend.
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.favorite, color: Colors.red),
                                      SizedBox(width: 5),
                                      Text(
                                        "${image['likes']}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.comment, color: Colors.white),
                                      SizedBox(width: 5),
                                      Text(
                                        "${image['comments']}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
