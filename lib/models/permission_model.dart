// lib/models/permission_model.dart

enum Permission {
  SEGURIDAD,
  MEMBRESIA,
  MINISTERIOS,
  FINANZAS,
  EVENTOS,
  REPORTES,
  CONFIGURACION,
}

// Función para mostrar nombres bonitos en la UI (opcional)
// Si prefieres que en la lista diga "Membresía" en lugar de "MEMBRESIA"
String getPermissionName(Permission permission) {
  switch (permission) {
    case Permission.SEGURIDAD:
      return 'Seguridad';
    case Permission.MEMBRESIA:
      return 'Membresía';
    case Permission.MINISTERIOS:
      return 'Ministerios';
    case Permission.FINANZAS:
      return 'Finanzas';
    case Permission.EVENTOS:
      return 'Eventos';
    case Permission.REPORTES:
      return 'Reportes';
    case Permission.CONFIGURACION:
      return 'Configuración';
    default:
      return permission.name;
  }
}
