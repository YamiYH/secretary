// lib/models/permission_model.dart

// Usamos un enum para tener una lista fija y segura de todos los permisos posibles.
enum Permission {
  // Permisos relacionados con Miembros
  viewMembers,
  createMembers,
  editMembers,
  deleteMembers,

  // Permisos relacionados con Asistencia
  viewAttendance,
  takeAttendance,
  editAttendance,

  // Permisos relacionados con Reportes
  viewReports,

  // Permisos relacionados con Usuarios y Roles (Administración)
  viewUsers,
  manageUsers, // Crear, editar, eliminar usuarios
  viewRoles,
  manageRoles, // Crear, editar, eliminar roles
}

// (Opcional) Una función helper para dar un nombre legible a cada permiso.
// Esto es muy útil para mostrarlo en la interfaz de usuario.
String getPermissionName(Permission permission) {
  switch (permission) {
    case Permission.viewMembers:
      return 'Ver Miembros';
    case Permission.createMembers:
      return 'Crear Miembros';
    case Permission.editMembers:
      return 'Editar Miembros';
    case Permission.deleteMembers:
      return 'Eliminar Miembros';
    case Permission.viewAttendance:
      return 'Ver Asistencia';
    case Permission.takeAttendance:
      return 'Tomar Asistencia';
    case Permission.editAttendance:
      return 'Editar Asistencia';
    case Permission.viewReports:
      return 'Ver Reportes';
    case Permission.viewUsers:
      return 'Ver Usuarios';
    case Permission.manageUsers:
      return 'Gestionar Usuarios';
    case Permission.viewRoles:
      return 'Ver Roles';
    case Permission.manageRoles:
      return 'Gestionar Roles';
    default:
      return 'Permiso desconocido';
  }
}
