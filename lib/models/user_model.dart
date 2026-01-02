// lib/models/user_model.dart
class User {
  final String id; // Útil para identificar unívocamente a cada usuario
  String name;
  String lastName;
  String phone;
  String role;

  User({
    required this.id,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.role,
  });
}
