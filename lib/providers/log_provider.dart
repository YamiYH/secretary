// lib/providers/log_provider.dart
import 'package:flutter/material.dart';

import '../models/log_model.dart';

class LogProvider with ChangeNotifier {
  final List<Log> _logs = [];

  // Usamos un getter que devuelve la lista en orden cronológico inverso (lo más nuevo primero)
  List<Log> get logs => List.from(_logs.reversed);

  // El único método público para añadir un nuevo registro
  void addLog({
    required String userName,
    required LogAction action,
    required LogEntity entity,
    required String details,
  }) {
    final newLog = Log(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      userId:
          'temp_user_id', // En un futuro, aquí iría el ID del usuario logueado
      userName: userName,
      action: action,
      entity: entity,
      details: details,
    );

    _logs.add(newLog);
    notifyListeners(); // Notifica a la pantalla de logs que hay un nuevo registro
  }
}
