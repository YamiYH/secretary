// lib/models/log_model.dart

// Un enum para definir los tipos de acciones posibles. Es más robusto que usar Strings.
enum LogAction { create, update, delete }

// Un enum para las entidades que pueden ser modificadas.
enum LogEntity { user, role, service, report }

class Log {
  final String id;
  final DateTime timestamp;
  final String userId;
  final String userName;
  final LogAction action;
  final LogEntity entity;
  final String details;

  Log({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.userName,
    required this.action,
    required this.entity,
    required this.details,
  });
}
