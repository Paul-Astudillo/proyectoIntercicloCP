import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'profile_page.dart';
import 'settings_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String userEmail;
  final String userId; // ID del usuario

  HomePage({required this.userEmail, required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  File? _selectedImage;
  String? _selectedFilter;
  final String _serverIP = '192.168.1.5'; // IP fija del servidor.
  final List<String> _filters = ['gauss', 'erosion', 'pencil', 'negative', 'partialcolor', 'swirl'];

  List<dynamic> _userImages = []; // Almacenamiento en memoria para las imágenes.
  bool _isLoadingImages = true;

  Future<void> _loadUserImages() async {
    if (_userImages.isNotEmpty) {
      // Si ya se cargaron las imágenes, no vuelvas a cargarlas.
      return;
    }

    final url = Uri.parse('http://$_serverIP:8000/api/images/');
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userImages = data;
          _isLoadingImages = false;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      setState(() {
        _isLoadingImages = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading images: $e')),
      );
    }
  }

  void _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _showFilterDialog();
    }
  }

  void _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      _showFilterDialog();
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Apply a Filter"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Text(
                      "Server IP: $_serverIP",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedFilter,
                    hint: Text("Select a Filter"),
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {
                      setDialogState(() {
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
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_selectedImage != null && _selectedFilter != null) {
                  Navigator.of(context).pop();
                  await _sendImageWithFilter(_selectedImage!, _selectedFilter!, widget.userId);
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

  Future<void> _sendImageWithFilter(File image, String filter, String userId) async {
    final url = Uri.parse('http://192.168.1.5:8000/api/process-image/');
    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['id_user'] = userId
        ..fields['filter_type'] = filter
        ..files.add(await http.MultipartFile.fromPath('img_original', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Filtro aplicado satisfactoriamente")),
        );
        setState(() {
          _userImages = []; // Limpia las imágenes para volver a cargarlas si es necesario.
        });
        await _loadUserImages();
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to apply filter: $responseBody');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al aplicar filtro: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserImages(); // Cargar las imágenes una sola vez al iniciar.
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
      body: _isLoadingImages
          ? Center(child: CircularProgressIndicator())
          : _userImages.isEmpty
              ? Center(
                  child: Text(
                    'No hay imágenes disponibles',
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
                              image['img_processed'] ?? '',
                              fit: BoxFit.cover,
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
                                Text(
                                  "Likes: ${image['likes'] ?? 0}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "Comments: ${image['comments']?.length ?? 0}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                builder: (context) => ProfilePage(userId: widget.userId),
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
