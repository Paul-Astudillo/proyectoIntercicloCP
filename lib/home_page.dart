import 'package:flutter/material.dart';
import 'feed_page.dart';
import 'profile_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onLogout;

  const HomePage({Key? key, required this.onLogout}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    FeedPage(),
    Profile_Page(),
  ];

  File? _selectedImage;

  // Función para seleccionar una imagen desde la galería
  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image selected: ${pickedFile.path}")),
      );
    }
  }

  // Función para tomar una foto con la cámara
  void _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Photo captured: ${pickedFile.path}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'PIXION',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: _selectedImage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    _selectedImage!,
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Selected Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.red, // Color rojo para el ítem seleccionado
        unselectedItemColor: Colors.red, // Color rojo para los ítems no seleccionados
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 2) {
            _takePhoto(); // Toma una foto
          } else if (index == 3) {
            _pickImageFromGallery(); // Selecciona una imagen de la galería
          } else {
            setState(() {
              _selectedImage = null; // Limpia la imagen al cambiar de página
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
            label: 'Take Photo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Upload Photo',
          ),
        ],
      ),
    );
  }
}
