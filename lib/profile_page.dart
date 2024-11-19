import 'package:flutter/material.dart';

class Profile_Page extends StatelessWidget {
  final List<Map<String, dynamic>> images = [
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
      'image': 'assets/images/photo4.png',
      'likes': 0,
      'comments': 0,
    },
    {
      'image': 'assets/images/photo3.png',
      'likes': 15,
      'comments': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000), // Rojo ladrillo
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Images: ${images.length}", // Cantidad de imágenes
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
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                return Card(
                  color: Colors.grey[900],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.asset(
                          image['image'],
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
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.comment, color: Colors.white),
                                SizedBox(width: 5),
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
