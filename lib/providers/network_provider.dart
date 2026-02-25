// lib/providers/network_provider.dart
import 'package:flutter/material.dart';

import '../models/network_model.dart';
import '../services/api_client.dart';

class NetworkProvider with ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<NetworkModel> _networks = [];
  bool _isLoading = false;

  List<NetworkModel> get networks => _networks;
  bool get isLoading => _isLoading;

  Future<void> fetchNetworks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.get('/networks');
      final List<dynamic> data = response.data['content'] ?? response.data;
      _networks = data.map((n) => NetworkModel.fromJson(n)).toList();
    } catch (e) {
      print("Error cargando redes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addNetwork(NetworkModel network) async {
    // Aquí irá la lógica del POST a la API
    notifyListeners();
  }

  // Método para actualizar (falta en tu provider)
  Future<void> updateNetwork(NetworkModel network) async {
    // Aquí irá la lógica del PUT a la API
    notifyListeners();
  }

  // Método para eliminar (falta en tu provider)
  Future<void> deleteNetwork(String id) async {
    // Aquí irá la lógica del DELETE a la API
    _networks.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
