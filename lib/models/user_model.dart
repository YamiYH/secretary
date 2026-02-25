// lib/models/user_model.dart
import 'member_model.dart';

class User {
  final String username;
  final String? password;
  final String role;
  final bool enabled;
  final String? memberId;
  final Member? member;

  User({
    required this.username,
    this.password,
    required this.role,
    required this.enabled,
    this.memberId,
    this.member,
  });

  //    Esta es la forma correcta de "actualizar" un objeto inmutable.
  User copyWith({
    String? id,
    String? userName,
    String? password,
    String? role,
    bool? enabled,
    String? memberId,
  }) {
    return User(
      username: userName ?? this.username,
      role: role ?? this.role,
      enabled: enabled ?? this.enabled,
      memberId: memberId ?? this.memberId,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    String roleName = 'Sin rol';

    final rolesList = json['roles'] as List<dynamic>?;

    // 2. Si la lista no es nula y no está vacía, tomamos el nombre del primer rol.
    if (rolesList != null && rolesList.isNotEmpty) {
      final firstRole = rolesList.first as Map<String, dynamic>;
      // Limpiamos el prefijo "ROLE_" para que sea más legible.
      roleName = (firstRole['name'] as String? ?? 'Sin rol')
          .toUpperCase()
          .replaceAll('ROLE_', '');
    }
    // 3. Extraemos el ID del miembro si el objeto 'member' no es nulo.
    final memberData = json['member'] as Map<String, dynamic>?;
    final memberId = memberData != null ? memberData['id'] as String? : null;
    final member = memberData != null ? Member.fromJson(memberData) : null;

    return User(
      username: json['username'] ?? 'N/A',
      role: roleName,
      enabled: json['enabled'] ?? false,
      memberId: memberId,
      member: member,
    );
  }
  Map<String, dynamic> toJson({String? password, List<String>? roleIds}) {
    final map = <String, dynamic>{
      'username': username,
      // El backend probablemente espera una lista de IDs de roles.
      'roleIds': roleIds,
      'memberId': memberId,
      'enabled': enabled,
    };

    // Añade la contraseña solo si se proporciona.
    if (password != null && password.isNotEmpty) {
      map['password'] = password;
    }
    return map;
  }
}
