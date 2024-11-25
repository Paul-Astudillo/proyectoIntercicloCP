import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<dynamic> _posts = []; // Lista dinámica para almacenar las publicaciones.
  bool _isLoading = true; // Indicador de carga.

  @override
  void initState() {
    super.initState();
    _fetchPosts(); // Cargar publicaciones al iniciar.
  }

  // Función para obtener publicaciones desde la API.
  Future<void> _fetchPosts() async {
    final url = Uri.parse('http://192.168.8.102:8000/api/posts/'); // Endpoint del backend
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _posts = data; // Se espera que 'data' sea una lista de publicaciones.
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $e')),
      );
    }
  }

  // Incrementar likes
  void _incrementLikes(int index) {
    setState(() {
      _posts[index]['likes'] += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Feed"),
        backgroundColor: Color(0xFF8B0000), // Rojo ladrillo.
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Muestra indicador de carga.
            )
          : ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Card(
                  color: Colors.grey[900],
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen de la publicación desde URL.
                      Image.network(
                        post['image_url'], // Campo de la URL de la imagen.
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.favorite, color: Colors.red),
                                  onPressed: () => _incrementLikes(index),
                                ),
                                Text(
                                  "${post['likes']} likes",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.comment, color: Colors.white),
                                SizedBox(width: 5),
                                Text(
                                  "${post['comments']} comments",
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
    );
  }
}
