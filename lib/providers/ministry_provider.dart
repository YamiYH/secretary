import 'package:flutter/material.dart';

import '../models/ministry_member_model.dart';
import '../models/ministry_model.dart';

class MinistryProvider with ChangeNotifier {
  // Lista de ejemplo. En el futuro, esto vendrá de una base de datos.
  List<MinistryModel> _ministries = [
    MinistryModel(
      id: '01',
      name: 'Misericordia',
      details: 'Personas vulnerables',
    ),
    MinistryModel(id: '02', name: 'Ensancha', details: 'Personas de negocios'),
    MinistryModel(
      id: '03',
      name: 'Libres como el viento',
      details: 'Personas presas',
    ),
  ];

  List<MinistryModel> get ministries => List.unmodifiable(_ministries);

  // 2. Lista privada para almacenar las relaciones
  List<MinistryMember> _ministryMembers = [
    // Datos de ejemplo:
    MinistryMember(
      ministryId: 'm1',
      memberId: 'mem1',
    ), // Juan Pérez en Misericordia
    MinistryMember(
      ministryId: 'm1',
      memberId: 'mem2',
    ), // María García en Misericordia
    MinistryMember(
      ministryId: 'm2',
      memberId: 'mem3',
    ), // Pedro Rodríguez en Ensancha
  ];

  // 3. Getter para obtener los IDs de los miembros de un ministerio específico
  List<String> getMemberIdsForMinistry(String ministryId) {
    return _ministryMembers
        .where((mm) => mm.ministryId == ministryId)
        .map((mm) => mm.memberId)
        .toList();
  }

  int getMemberCountForMinistry(String ministryId) {
    // Simplemente contamos cuántas veces aparece el ministryId en nuestra lista de relaciones.
    return _ministryMembers.where((mm) => mm.ministryId == ministryId).length;
  }

  // 4. Método para agregar un miembro a un ministerio
  void addMemberToMinistry(String ministryId, String memberId) {
    // Evitar duplicados
    final exists = _ministryMembers.any(
      (mm) => mm.ministryId == ministryId && mm.memberId == memberId,
    );

    if (!exists) {
      _ministryMembers.add(
        MinistryMember(ministryId: ministryId, memberId: memberId),
      );
      notifyListeners();
    }
  }

  // 5. Método para eliminar un miembro de un ministerio
  void removeMemberFromMinistry(String ministryId, String memberId) {
    _ministryMembers.removeWhere(
      (mm) => mm.ministryId == ministryId && mm.memberId == memberId,
    );
    notifyListeners();
  }

  void addMinistry(MinistryModel ministry) {
    final newMinistry = MinistryModel(
      id: DateTime.now().toString(), // ID único simple
      name: ministry.name,
      details: ministry.details,
    );
    _ministries = [..._ministries, newMinistry];

    notifyListeners(); // Notifica a los widgets que escuchan para que se redibujen
  }

  void updateMinistry(MinistryModel updatedMinistry) {
    {
      // Creamos una lista completamente nueva usando .map()
      _ministries = _ministries.map(
        (ministry) {
          // Si el ID coincide, devolvemos el ministerio actualizado.
          // Si no, devolvemos el ministerio original sin cambios.
          return ministry.id == updatedMinistry.id ? updatedMinistry : ministry;
        },
      ).toList(); // .toList() convierte el resultado del map en una nueva lista.

      notifyListeners();
    }
  }

  void deleteMinistry(String ministryId) {
    _ministries = _ministries
        .where((ministry) => ministry.id != ministryId)
        .toList();
    notifyListeners();
  }
}
