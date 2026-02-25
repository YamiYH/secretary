// lib/providers/pastor_provider.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/pastor_model.dart';
import '../services/api_client.dart';

class PastorProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<PastorModel> _pastors = [];
  bool _isLoading = false;

  List<PastorModel> get pastors => _pastors;
  bool get isLoading => _isLoading;

  // --- NUEVO MÉTODO PARA CARGAR PASTORES DESDE LA API ---
  Future<void> fetchPastors() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.get(
        '/pastors',
      ); // Llama a GET /api/v1/pastors

      // El Swagger indica que la respuesta es una lista de objetos
      final List<dynamic> pastorData = response.data;

      // Convertimos los datos JSON en una lista de PastorModel
      _pastors = pastorData.map((data) => PastorModel.fromJson(data)).toList();
    } on DioException catch (e) {
      // Aquí podrías manejar errores específicos de la API
      print('Error al cargar pastores: $e');
      _pastors = []; // En caso de error, dejamos la lista vacía
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica a los widgets para que se redibujen
    }
  }

  // Obtener un pastor por su ID
  PastorModel findById(String id) {
    return _pastors.firstWhere(
      (pastor) => pastor.id == id,
      orElse: () => const PastorModel(id: 'not_found', name: 'No encontrado'),
    );
  }

  // Futuro: Método para añadir un pastor
  Future<void> addPastor(PastorModel pastor) async {
    await fetchPastors();
  }

  // Futuro: Método para actualizar un pastor
  void updatePastor(PastorModel updatedPastor) {
    final index = _pastors.indexWhere((p) => p.id == updatedPastor.id);
    if (index != -1) {
      _pastors[index] = updatedPastor;
      notifyListeners();
    }
  }

  // Futuro: Método para eliminar un pastor
  void deletePastor(String id) {
    _pastors.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
