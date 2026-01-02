// lib/providers/role_provider.dart
import 'package:flutter/material.dart';

import '../models/role_model.dart';

class RoleProvider with ChangeNotifier {
  // Lista privada de roles (nuestra "base de datos" en memoria)
  final List<Role> _roles = [
    Role(
      id: 'r1',
      name: 'Administrador',
      description: 'Acceso total al sistema',
    ),
    Role(
      id: 'r2',
      name: 'Editor',
      description: 'Puede crear y modificar contenido',
    ),
    Role(id: 'r3', name: 'Miembro', description: 'Acceso de solo lectura'),
    Role(
      id: 'r4',
      name: 'Visitante',
      description: 'Acceso limitado a áreas públicas',
    ),
  ];

  // Getter público para leer la lista
  List<Role> get roles => _roles;

  // --- Funciones CRUD ---

  void addRole(Role role) {
    _roles.add(role);
    notifyListeners();
  }

  void updateRole(Role updatedRole) {
    final index = _roles.indexWhere((role) => role.id == updatedRole.id);
    if (index != -1) {
      _roles[index] = updatedRole;
      notifyListeners();
    }
  }

  void deleteRole(String id) {
    _roles.removeWhere((role) => role.id == id);
    notifyListeners();
  }
}
