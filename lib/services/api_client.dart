// lib/services/api_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl:
              'https://vri-secretary-backend-production.up.railway.app/api/v1',
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Obtiene el token guardado
          final token = await _secureStorage.read(key: 'auth_token');
          if (token != null) {
            // Si hay un token, lo añade a la cabecera 'Authorization'
            options.headers['Authorization'] = 'Bearer $token';
          } else {
            print('No se encontró token para la petición a: ${options.path}');
          }
          // Continúa con la petición
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Opcional: puedes imprimir algo en cada respuesta exitosa
          print(
            'Respuesta recibida: ${response.statusCode} desde ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // Opcional: si recibes un error 401 (No autorizado),
          // podrías redirigir al login automáticamente.
          // Por ahora, solo dejamos que el error continúe.
          print('Error en la petición: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // Getter para que los providers puedan usar la instancia de Dio ya configurada
  Dio get dio => _dio;
}
