// lib/providers/attendance_provider.dart
import 'package:flutter/material.dart';

import '../models/attendance_record_model.dart';

class AttendanceProvider with ChangeNotifier {
  // "Base de datos" en memoria de todos los registros de asistencia
  final Map<String, AttendanceRecord> _records = {};

  // Getter para acceder a los registros
  Map<String, AttendanceRecord> get records => _records;

  // Método para guardar o actualizar un registro de asistencia
  void saveRecord(AttendanceRecord record) {
    _records[record.id] = record;
    notifyListeners();
    print("Registro guardado para la fecha: ${record.id}");
    print("Miembros presentes: ${record.presentMemberIds.length}");
    print("Visitas: ${record.guestCount}");
  }

  // Método para obtener un registro para una fecha específica
  AttendanceRecord? getRecordForDate(DateTime date) {
    final String id =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    return _records[id];
  }
}
