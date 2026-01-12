// lib/models/user_model.dart
class User {
  final String id; // Útil para identificar unívocamente a cada usuario
  final String userName;
  final String password;
  final String role;
  final String? memberId;

  User({
    required this.id,
    required this.userName,
    required this.password,
    required this.role,
    this.memberId,
  });

  //    Esta es la forma correcta de "actualizar" un objeto inmutable.
  User copyWith({
    String? id,
    String? userName,
    String? password,
    String? role,
    String? memberId,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      password: password ?? this.password,
      role: role ?? this.role,
      memberId: memberId ?? this.memberId,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Proporciona un valor por defecto si el ID es nulo
      id: json['id'] as String? ?? '',

      // Proporciona un valor por defecto si userName es nulo
      userName: json['userName'] as String? ?? 'Usuario sin nombre',

      password: json['password'] as String? ?? '',

      // Proporciona un valor por defecto si el rol es nulo
      role: json['role'] as String? ?? 'Miembro',
      memberId: json['memberId'] as String?,
    );
  }

  // También es buena idea reforzar el método toJson si lo tienes
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'password': password,
      'role': role,
      'memberId': memberId,
    };
  }
}
