// lib/models/role_model.dart

class Role {
  final String id;
  final String name;
  final String description;
  final List<String>
  permissions; // El backend nos da una lista de Strings, así que usamos eso.
  final bool enabled;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.enabled,
  });

  // Getter para mostrar un nombre limpio en la UI (ej: "ADMIN" en lugar de "ROLE_ADMIN")
  String get displayName => name.replaceAll('ROLE_', '');

  // El método fromJson ahora es mucho más simple.
  factory Role.fromJson(Map<String, dynamic> json) {
    // Convierte la lista de permisos de List<dynamic> a List<String> de forma segura.
    final permissionsData = json['permissions'] as List<dynamic>?;
    final permissionsList =
        permissionsData?.map((p) => p.toString()).toList() ?? [];

    return Role(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Sin Nombre',
      description: json['description'] ?? 'Sin Descripción',
      permissions: permissionsList,
      enabled: json['enabled'] ?? false,
    );
  }
}
