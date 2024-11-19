class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  final Map<String, String> _users = {
    'paul': '1234', // Usuario de ejemplo
  };

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Método para insertar un usuario
  Future<void> insertUser(String email, String password) async {
    if (_users.containsKey(email)) {
      throw Exception("User already exists!");
    }
    _users[email] = password;
  }

  // Método para validar un usuario
  Future<bool> validateUser(String email, String password) async {
    return _users[email] == password;
  }
}