import 'package:flutter/material.dart';
import 'login_page.dart';

void main() {
  runApp(SocialApp());
}

class SocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social App',
      theme: ThemeData(
        primaryColor: Color(0xFF8B0000),
        scaffoldBackgroundColor: Color(0xFF1C1C1C),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // Actualización
          bodyMedium: TextStyle(color: Colors.white), // Actualización
        ),
      ),
      home: LoginPage(),
    );
  }
}
