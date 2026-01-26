// lib/models/role_model.dart
import 'package:app/models/permission_model.dart';

class Role {
  final String id;
  String name;
  String description;
  final List<Permission> permissions;

  Role({
    required this.id,
    required this.name,
    required this.description,
    this.permissions = const [],
  });

  Role copyWith({
    String? id,
    String? name,
    String? description,
    List<Permission>? permissions,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
    );
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    // Leemos la lista de permisos como strings
    final List<String> permissionsFromJson =
        (json['permissions'] as List<dynamic>?)
            ?.map((p) => p.toString())
            .toList() ??
        [];

    // Convertimos los strings de vuelta a nuestro enum Permission
    final List<Permission> permissionsList = permissionsFromJson
        .map(
          (pStr) => Permission.values.firstWhere(
            (e) => e.toString() == pStr,
            orElse: () => Permission
                .viewMembers, // Un valor seguro por si no lo encuentra
          ),
        )
        .toList();

    return Role(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Sin nombre',
      description: json['description'] as String? ?? 'Sin descripción',
      permissions: permissionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      // Convertimos la lista de enums a una lista de strings para guardarla
      'permissions': permissions.map((p) => p.toString()).toList(),
    };
  }
}
