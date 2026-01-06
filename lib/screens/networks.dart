import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/create/create_network.dart';
import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../models/attendance_record_model.dart';
import '../models/member_model.dart';
import '../providers/attendance_provider.dart';
import '../providers/member_provider.dart';
import '../widgets/menu.dart';

class Networks extends StatefulWidget {
  const Networks({super.key});

  @override
  State<Networks> createState() => _NetworksState();
}

class _NetworksState extends State<Networks> {
  final Map<String, IconData> _groupIcons = {
    'Niños': Icons.child_care,
    'Juveniles': Icons.sports_esports,
    'Jóvenes': Icons.school,
    'Mujeres': Icons.woman,
    'Hombres': Icons.man,
    '3ra Edad': Icons.elderly,
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    // --- CAMBIO 1: Conectar a los Providers ---
    final memberProvider = Provider.of<MemberProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final List<Member> allMembers = memberProvider.allMembers;
    final List<AttendanceRecord> allRecords = attendanceProvider.records.values
        .toList();

    // --- CAMBIO 2: Generar la lista de grupos dinámicamente ---
    // Usamos un Set para obtener los nombres de grupo únicos y luego lo convertimos a lista.
    final List<String> groupNames = allMembers
        .map((m) => m.group)
        .toSet()
        .toList();
    groupNames.sort(); // Ordenamos alfabéticamente

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Redes', isDrawerEnabled: isMobile),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) Menu(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 3. El encabezado (título y botón)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Redes',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AddButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            createFadeRoute(CreateNetwork()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // 4. La grilla, que ocupa todo el espacio vertical restante
                  Expanded(
                    child: GridView.builder(
                      // Quitamos shrinkWrap, ya no es necesario
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 350.0,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                      itemCount: groupNames.length,
                      itemBuilder: (context, index) {
                        // La lógica interna no cambia
                        final groupName = groupNames[index];
                        final membersInGroup = allMembers
                            .where((m) => m.group == groupName)
                            .toList();
                        final memberCount = membersInGroup.length;
                        final groupMemberIds = membersInGroup
                            .map((m) => m.id)
                            .toSet();
                        int totalGroupAttendance = 0;
                        for (var record in allRecords) {
                          totalGroupAttendance += record.presentMemberIds
                              .where((id) => groupMemberIds.contains(id))
                              .length;
                        }
                        final double avgAttendance = allRecords.isNotEmpty
                            ? totalGroupAttendance / allRecords.length
                            : 0.0;

                        return _buildGroupCard(
                          title: groupName,
                          memberCount: memberCount,
                          avgAttendance: avgAttendance,
                          icon:
                              _groupIcons[groupName] ??
                              _groupIcons['Default'] ??
                              Icons.group,
                          onTap: () {
                            print(
                              'Navegar a los detalles del grupo: $groupName',
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para las tarjetas de grupo
  Widget _buildGroupCard({
    required String title,
    required int memberCount,
    required double avgAttendance,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 36, color: primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // Mostramos el número de miembros
                    Flexible(
                      child: Text(
                        '$memberCount Miembros',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Mostramos la asistencia promedio
                    Flexible(
                      child: Text(
                        '${avgAttendance.toStringAsFixed(1)} Asist. Promedio',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
