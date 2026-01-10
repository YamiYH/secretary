import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../colors.dart';
import '../../../models/member_model.dart';
import '../../../providers/member_provider.dart';
import '../../../widgets/custom_appbar.dart';
import '../../models/network_model.dart';

class NetworkDetail extends StatelessWidget {
  final NetworkModel network;

  const NetworkDetail({Key? key, required this.network}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. Obtener el provider de miembros
    final memberProvider = Provider.of<MemberProvider>(context);

    // 2. Filtrar la lista para obtener solo los miembros de este grupo
    final List<Member> membersInGroup = memberProvider.allMembers
        .where((member) => member.group == network.name)
        .toList();

    // Opcional: Ordenar la lista de miembros alfabéticamente
    membersInGroup.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: network.name, // El título del AppBar es el nombre de la red
      ),
      body: membersInGroup.isEmpty
          ? const Center(
              child: Text(
                'No hay miembros en esta red.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: membersInGroup.length,
              itemBuilder: (context, index) {
                final member = membersInGroup[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: primaryColor.withOpacity(0.1),
                      foregroundColor: primaryColor,
                      child: Text(
                        member.name.isNotEmpty
                            ? member.name[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      '${member.name} ${member.lastName}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('${member.address} \n${member.phone}'),

                    // 1. Quita el ícono de la flecha
                    // trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),

                    // 2. Quita la acción de onTap
                    // onTap: () { ... },
                  ),
                );
              },
            ),
    );
  }

  // Widget para cuando no hay miembros en la red
  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No hay miembros en esta red',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget para construir la lista de miembros
  Widget _buildMemberList(List<Member> members) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: accentColor.withOpacity(0.2),
              foregroundColor: accentColor,
              child: Text(
                member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              '${member.name} ${member.lastName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Se unió: ${DateFormat('dd MMM yyyy', 'es_ES').format(member.registrationDate)}',
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              // Futuro: Navegar al perfil detallado del miembro individual
              print('Ver detalles de ${member.name}');
            },
          ),
        );
      },
    );
  }
}
