// lib/providers/role_provider.dart

import 'package:dio/dio.dart'; // Necesitamos Dio para las llamadas HTTP
import 'package:flutter/material.dart';

import '../models/role_model.dart';
import '../services/api_client.dart'; // Y nuestro cliente API

class RoleProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<Role> _roles = []; // La lista ahora empieza vacía.
  bool _isLoading = false;
  String? _error;

  // Getters públicos para que la UI pueda acceder al estado
  List<Role> get roles => _roles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // --- MÉTODO PARA OBTENER LOS ROLES DEL BACKEND ---
  Future<void> fetchRoles() async {
    // Si ya estamos cargando, no hacemos nada para evitar llamadas duplicadas.
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners(); // Notifica a la UI que estamos cargando.

    try {
      final response = await _apiClient.dio.get('/roles');

      // La respuesta de tu API es paginada, así que los datos están en la clave "content".
      final List<dynamic> roleData = response.data['content'];

      // Convertimos cada objeto JSON de la lista en un objeto Role.
      _roles = roleData.map((data) => Role.fromJson(data)).toList();
    } on DioException catch (e) {
      _error = 'Error al cargar roles: ${e.message}';
      print(_error);
      _roles = []; // En caso de error, dejamos la lista vacía.
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica a la UI que la carga ha terminado (con éxito o error).
    }
  }

  /*
    // Dejamos estos métodos para después, cuando implementemos la edición de roles.

    Future<void> addRole(Role role) async { ... }
    Future<void> updateRole(Role role) async { ... }
    Future<void> deleteRole(String id) async { ... }
  */
}
