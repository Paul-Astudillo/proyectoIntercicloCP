import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedPage extends StatefulWidget {
  final String userId; // ID del usuario actual

  FeedPage({required this.userId});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<dynamic> _allImages = [];
  bool _isLoading = true;
  final String _serverIP = '192.168.1.5'; // Cambia esto a la IP del servidor

  // Cargar todas las imágenes desde el backend.
  Future<void> _loadAllImages() async {
    final url = Uri.parse('http://$_serverIP:8000/api/images');
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          setState(() {
            _allImages = data;
            _isLoading = false;
          });
        } else {
          throw Exception('Formato de respuesta inválido');
        }
      } else {
        throw Exception('Error al cargar imágenes: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cargando imágenes: $e')),
      );
    }
  }

  // Enviar un like a una imagen.
  Future<void> _sendLike(int imageId) async {
    final url = Uri.parse('http://$_serverIP:8000/api/images/$imageId/like');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id_user": int.parse(widget.userId)}),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Actualizar los likes localmente.
          final index = _allImages.indexWhere((img) => img['id'] == imageId);
          if (index != -1) {
            _allImages[index]['likes'] =
                (_allImages[index]['likes'] ?? 0) + 1; // Incrementa los likes.
          }
        });
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception('Error al dar like: $errorBody');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al dar like: $e')),
      );
    }
  }

  // Agregar un comentario a una imagen.
  Future<void> _addComment(int imageId, String comment) async {
    final url = Uri.parse('http://$_serverIP:8000/api/add-comment/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id_image": imageId,
          "id_user": int.parse(widget.userId),
          "comment": comment,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Actualizar los comentarios localmente.
          final index = _allImages.indexWhere((img) => img['id'] == imageId);
          if (index != -1) {
            _allImages[index]['comments'] = _allImages[index]['comments'] ?? [];
            _allImages[index]['comments'].add({"comment": comment});
          }
        });
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception('Error al agregar comentario: $errorBody');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar comentario: $e')),
      );
    }
  }

  // Mostrar diálogo para agregar un comentario.
  void _showCommentDialog(int imageId) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Comentario"),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: "Escribe tu comentario"),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final comment = commentController.text.trim();
                if (comment.isNotEmpty) {
                  Navigator.of(context).pop();
                  await _addComment(imageId, comment);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("El comentario no puede estar vacío")),
                  );
                }
              },
              child: Text("Enviar"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAllImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000),
        title: Text(
          "Feed",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _allImages.isEmpty
              ? Center(
                  child: Text(
                    "No hay imágenes disponibles",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _allImages.length,
                  itemBuilder: (context, index) {
                    final image = _allImages[index];
                    return Card(
                      color: Colors.grey[900],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Image.network(
                              image['img_processed'], // URL de la imagen.
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                  ),
                                );
                              },
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
                                    IconButton(
                                      icon: Icon(Icons.thumb_up, color: Colors.white),
                                      onPressed: () => _sendLike(image['id']),
                                    ),
                                    Text(
                                      "Likes: ${image['likes'] ?? 0}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.comment, color: Colors.white),
                                  onPressed: () => _showCommentDialog(image['id']),
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
