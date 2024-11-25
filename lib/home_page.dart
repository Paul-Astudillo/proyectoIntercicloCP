import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_page.dart';
import 'settings_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String userEmail;

  HomePage({required this.userEmail});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  File? _selectedImage;
  String? _selectedFilter;
  final String _serverIP = '192.168.8.102'; // IP fija del servidor.
  final List<String> _filters = ['Gauss', 'Erosion', 'Lapiz', 'Negative', 'Parcial Color', 'Swirl'];

  final List<dynamic> _userImages = []; // Imágenes cargadas desde la base de datos.

  // Función para cargar imágenes desde la base de datos.
  Future<void> _loadUserImages() async {
    final url = Uri.parse('http://$_serverIP:8000/api/images/');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userImages.clear();
          _userImages.addAll(data); // Se espera que data sea una lista de imágenes.
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading images: $e')),
      );
    }
  }

  // Función para seleccionar una imagen de la galería y aplicar filtro.
  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      _showFilterDialog(); // Mostrar el diálogo para elegir filtros.
    }
  }

  // Función para tomar una foto con la cámara y aplicar filtro.
  void _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      _showFilterDialog(); // Mostrar el diálogo para elegir filtros.
    }
  }

  // Mostrar un cuadro de diálogo para seleccionar filtros y enviar datos.
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apply a Filter"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Campo no editable para mostrar la IP del servidor.
              TextField(
                controller: TextEditingController(text: _serverIP),
                decoration: InputDecoration(labelText: "Server IP"),
                readOnly: true,
              ),
              SizedBox(height: 20),
              // Lista desplegable para seleccionar un filtro.
              DropdownButton<String>(
                value: _selectedFilter,
                hint: Text("Select a Filter"),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilter = newValue;
                  });
                },
                items: _filters.map<DropdownMenuItem<String>>((String filter) {
                  return DropdownMenuItem<String>(
                    value: filter,
                    child: Text(filter),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_selectedImage != null && _selectedFilter != null) {
                  Navigator.of(context).pop(); // Cerrar diálogo antes de enviar.
                  await _sendImageWithFilter(_selectedImage!, _selectedFilter!);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select an image and a filter")),
                  );
                }
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }

  // Enviar la imagen y el filtro seleccionado al servidor.
  Future<void> _sendImageWithFilter(File image, String filter) async {
    final url = Uri.parse('http://$_serverIP:8000/api/apply_filter/');
    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['filter'] = filter
        ..files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Filter applied successfully")),
        );
        _loadUserImages(); // Recargar imágenes después de enviar.
      } else {
        throw Exception('Failed to apply filter');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error applying filter: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C1C),
      appBar: AppBar(
        backgroundColor: Color(0xFF8B0000),
        title: Text(
          'Feed',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GridView.builder(
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
            child: Image.network(
              image['url'], // URL de la imagen desde la base de datos.
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF1C1C1C),
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            _takePhoto();
          } else if (index == 2) {
            _pickImageFromGallery();
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(userEmail: widget.userEmail),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ),
            );
          } else {
            setState(() {
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
            icon: Icon(Icons.photo_camera),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
