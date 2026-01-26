// lib/providers/pastor_provider.dart

import 'package:flutter/material.dart';

import '../models/pastor_model.dart';

class PastorProvider with ChangeNotifier {
  // Lista privada de pastores. En el futuro, esta lista se llenará
  // con datos de tu backend/API.
  final List<PastorModel> _pastors = [
    const PastorModel(id: 'p1', name: 'Juan Pérez'),
    const PastorModel(id: 'p2', name: 'Ana García'),
    const PastorModel(id: 'p3', name: 'Carlos Rodríguez'),
    const PastorModel(id: 'p4', name: 'Sofía Martínez'),
    const PastorModel(id: 'p5', name: 'Laura Fernández'), // He añadido uno más
  ];

  // Getter público para acceder a la lista de pastores.
  List<PastorModel> get pastors => _pastors;

  // --- Métodos para gestionar los pastores (preparados para el futuro) ---

  // Obtener un pastor por su ID
  PastorModel findById(String id) {
    return _pastors.firstWhere(
      (pastor) => pastor.id == id,
      orElse: () =>
          const PastorModel(id: 'not_found', name: 'Pastor no encontrado'),
    );
  }

  // Obtener una lista de nombres de pastores a partir de una lista de IDs
  String getPastorNamesByIds(List<String> ids) {
    if (ids.isEmpty) return 'Ninguno';
    return ids.map((id) => findById(id).name).join(', ');
  }

  // Futuro: Método para añadir un pastor
  void addPastor(PastorModel pastor) {
    _pastors.add(pastor);
    notifyListeners(); // Notifica a los widgets que escuchan para que se redibujen
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
