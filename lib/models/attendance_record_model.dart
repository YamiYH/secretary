// lib/models/attendance_record_model.dart

class AttendanceRecord {
  final String id; // ID único, podría ser la fecha en formato 'yyyy-MM-dd'
  final DateTime date;
  final int guestCount;
  final int pastoralVisitCount;
  final Set<String> presentMemberIds; // Usamos un Set de IDs para eficiencia

  AttendanceRecord({
    required this.id,
    required this.date,
    required this.guestCount,
    required this.pastoralVisitCount,
    required this.presentMemberIds,
  });
}
