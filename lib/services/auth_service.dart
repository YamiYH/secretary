// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://vri-secretary-backend-production.up.railway.app/api/v1',
    ),
  );
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Método para guardar el token
  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  // Método para obtener el token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  // Método para borrar el token (al cerrar sesión)
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Método para Iniciar Sesión
  // Devuelve null si fue exitoso, o un mensaje de error si falló.
  Future<String?> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200 && response.data['jwtToken'] != null) {
        final token = response.data['jwtToken'];
        await _saveToken(token); // Guardamos el token
        return null; // Éxito
      }
      return 'Respuesta inesperada del servidor.';
    } on DioException catch (e) {
      // Manejo de errores de Dio (ej. 403 Forbidden si las credenciales son incorrectas)
      if (e.response?.statusCode == 403) {
        return 'Usuario o contraseña incorrectos.';
      }
      return 'Error de conexión. Inténtalo de nuevo.';
    } catch (e) {
      return 'Ocurrió un error inesperado.';
    }
  }

  // Método para Cerrar Sesión
  Future<void> signOut() async {
    await deleteToken();
    notifyListeners();
  }
}
