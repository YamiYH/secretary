// lib/providers/user_provider.dart
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  // Lista privada de usuarios (nuestra "base de datos" en memoria)
  final List<User> _users = [
    // Datos de ejemplo para empezar
    User(
      id: '1',
      name: 'Olivia',
      lastName: 'Bennett',
      phone: '123-456-7890',
      role: 'Administrador',
    ),
    User(
      id: '2',
      name: 'Ethan',
      lastName: 'Carter',
      phone: '234-567-8901',
      role: 'Miembro',
    ),
  ];

  // Getter público para que los widgets puedan leer la lista de usuarios
  List<User> get users => _users;

  // Método para añadir un nuevo usuario
  void addUser(User user) {
    _users.add(user);
    // ¡Esto es clave! Notifica a todos los widgets que están "escuchando"
    // que los datos han cambiado y que necesitan redibujarse.
    notifyListeners();
  }

  // (Opcional) Métodos para eliminar o actualizar usuarios
  void deleteUser(String id) {
    _users.removeWhere((user) => user.id == id);
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    // Busca el índice del usuario que tiene el mismo ID
    final userIndex = _users.indexWhere((user) => user.id == updatedUser.id);
    if (userIndex >= 0) {
      // Si lo encuentra, lo reemplaza en esa posición
      _users[userIndex] = updatedUser;
      notifyListeners(); // Notifica a los widgets para que se redibujen
    }
  }
}
