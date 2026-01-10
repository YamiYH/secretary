// lib/providers/service_type_provider.dart
import 'package:flutter/material.dart';

import '../models/service_type_model.dart';

class ServiceTypeProvider with ChangeNotifier {
  final List<ServiceType> _serviceTypes = [
    ServiceType(id: 'st1', name: 'Celebración General'),
    ServiceType(id: 'st2', name: 'Tiempo de Adoración'),
    ServiceType(id: 'st3', name: 'Servicio de Jóvenes'),
    ServiceType(id: 'st4', name: 'Estudio Bíblico'),
  ];

  List<ServiceType> get serviceTypes => _serviceTypes;

  void addServiceType(String name) {
    final newType = ServiceType(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    _serviceTypes.add(newType);
    notifyListeners();
  }

  void deleteServiceType(String id) {
    _serviceTypes.removeWhere((type) => type.id == id);
    notifyListeners();
  }

  // --- ¡AÑADE ESTE MÉTODO AQUÍ! ---
  void updateServiceType(String id, String newName) {
    // Buscamos el índice del elemento que queremos actualizar.
    final typeIndex = _serviceTypes.indexWhere((type) => type.id == id);

    // Si lo encontramos (si indexWhere no devuelve -1), actualizamos su nombre.
    if (typeIndex != -1) {
      // Creamos una nueva instancia para asegurar la inmutabilidad y la reactividad.
      final updatedType = ServiceType(id: id, name: newName);
      _serviceTypes[typeIndex] = updatedType;
      notifyListeners(); // Notificamos a los widgets para que se redibujen.
    }
  }
}
