// lib/providers/member_provider.dart
import 'package:flutter/material.dart';

import '../models/member_model.dart';

class MemberProvider with ChangeNotifier {
  // --- ESTADO INTERNO DEL PROVIDER ---

  // 1. La lista maestra de todos los miembros (nuestra "base de datos" en memoria)
  final List<Member> _allMembers = [
    Member(
      id: 'm1',
      name: 'Ethan',
      lastName: 'Carter',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: 'Jóvenes',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm2',
      name: 'Olivia',
      lastName: 'Bennett',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: 'Mujeres',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm3',
      name: 'Noah',
      lastName: 'Thompson',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: 'Hombres',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm4',
      name: 'Sophia',
      lastName: 'Ramirez',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: 'Jóvenes',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm5',
      name: 'Liam',
      lastName: ' Walker',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: 'Hombres',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm6',
      name: 'Ava Rodriguez',
      lastName: 'Walker',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: 'Jóvenes',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm7',
      name: 'Jackson',
      lastName: 'Davis',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: 'Hombres',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm8',
      name: 'Isabella',
      lastName: 'Lewis',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: '3ra Edad',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm9',
      name: 'Carlos',
      lastName: 'Garcia',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: 'Jóvenes',
      registrationDate: DateTime(2023, 1, 15),
    ),
    Member(
      id: 'm10',
      name: 'Maria',
      lastName: 'Fernandez',
      phone: '111-222-333',
      address: 'Calle Falsa 123',
      birthDate: DateTime(2023, 1, 15),
      group: '3ra Edad',
      registrationDate: DateTime(2023, 1, 15),
    ),
  ];

  // 2. El término de búsqueda actual
  String _searchQuery = '';

  List<Member> get allMembers => _allMembers;

  List<Member> get filteredMembers {
    if (_searchQuery.isEmpty) {
      return _allMembers; // Si no hay búsqueda, devuelve todos.
    } else {
      // Si hay búsqueda, filtra la lista maestra.
      return _allMembers.where((member) {
        final query = _searchQuery.toLowerCase();
        final fullName = '${member.name} ${member.lastName}'.toLowerCase();
        final nameMatches = fullName.contains(query);
        final groupMatches = member.group.toLowerCase().contains(query);
        return nameMatches || groupMatches;
      }).toList();
    }
  }

  // --- ACCIONES (Métodos para modificar el estado) ---

  // Acción para actualizar el término de búsqueda.
  void search(String query) {
    _searchQuery = query;
    // Notifica a todos los widgets que escuchan para que se reconstruyan con la nueva lista filtrada.
    notifyListeners();
  }

  // Aquí irán las futuras funciones CRUD
  void addMember(Member member) {
    _allMembers.add(member);
    notifyListeners();
  }

  void updateMember(Member updatedMember) {
    final index = _allMembers.indexWhere(
      (member) => member.id == updatedMember.id,
    );
    if (index != -1) {
      _allMembers[index] = updatedMember;
      notifyListeners();
    }
  }

  void deleteMember(String id) {
    _allMembers.removeWhere((member) => member.id == id);
    notifyListeners();
  }
}
