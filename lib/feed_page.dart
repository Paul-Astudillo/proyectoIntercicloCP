import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  // Lista de publicaciones (imágenes) con datos de likes y comentarios
  final List<Map<String, dynamic>> _posts = [
    {
      'image': 'assets/images/photo1.png',
      'likes': 10,
      'comments': 2,
    },
    {
      'image': 'assets/images/photo2.png',
      'likes': 25,
      'comments': 5,
    },
    {
      'image': 'assets/images/photo3.png',
      'likes': 15,
      'comments': 1,
    },
  ];

  void _incrementLikes(int index) {
    setState(() {
      _posts[index]['likes'] += 1; // Incrementar likes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Feed"),
        backgroundColor: Color(0xFF8B0000), // Rojo ladrillo
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return Card(
            color: Colors.grey[900],
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen de la publicación
                Image.asset(
                  post['image'],
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
