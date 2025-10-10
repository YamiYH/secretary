// lib/providers/service_provider.dart
import 'package:flutter/material.dart';

import '../models/service_model.dart'; // Asegúrate de que la ruta sea correcta

class ServiceProvider with ChangeNotifier {
  // Lista privada de servicios
  final List<ServiceModel> _services = [
    ServiceModel(
      title: 'Culto Matutino',
      date: DateTime(2024, 7, 21),
      time: const TimeOfDay(hour: 9, minute: 0),
      preacher: 'Pastor Principal',
      worshipMinister: 'Líder de Alabanza',
    ),
    ServiceModel(
      title: 'Servicio de Mitad de Semana',
      date: DateTime(2024, 7, 24),
      time: const TimeOfDay(hour: 19, minute: 30),
      preacher: 'Pastor Asociado',
      worshipMinister: 'Equipo de Alabanza',
    ),
    ServiceModel(
      title: 'Convivencia Juvenil',
      date: DateTime(2024, 7, 26),
      time: const TimeOfDay(hour: 21, minute: 0),
      preacher: 'Líder de Jóvenes',
      worshipMinister: 'Banda Juvenil',
    ),
  ];

  // Getter público para que los widgets puedan leer la lista
  List<ServiceModel> get services => _services;

  // Método para añadir un nuevo servicio
  void addService(ServiceModel service) {
    _services.add(service);
    _services.sort(
      (a, b) => a.date.compareTo(b.date),
    ); // Opcional: mantener la lista ordenada por fecha
    notifyListeners(); // ¡Crucial! Notifica a los widgets que escuchan que hubo un cambio.
  }

  // Puedes añadir aquí la lógica para _getEventsForDay que tenías en create_service
  List<ServiceModel> getEventsForDay(DateTime day) {
    return _services.where((event) {
      // Compara solo el año, mes y día
      return event.date.year == day.year &&
          event.date.month == day.month &&
          event.date.day == day.day;
    }).toList();
  }
}
