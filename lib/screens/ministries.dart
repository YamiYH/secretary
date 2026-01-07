import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/create/create_ministry.dart';
import 'package:app/screens/ministries_manage.dart';
import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../models/ministry_model.dart';
import '../providers/ministry_provider.dart';
import '../widgets/button.dart';
import '../widgets/menu.dart';
import 'ministry_member.dart';

class Ministries extends StatelessWidget {
  const Ministries({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    // Usamos context.watch para que esta pantalla se reconstruya
    // cada vez que los datos en MinistryProvider cambien.
    final ministryProvider = context.watch<MinistryProvider>();
    final List<MinistryModel> ministries = ministryProvider.ministries;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Ministerios', isDrawerEnabled: isMobile),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const SizedBox(child: Menu()),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ministerios',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Row(
                        children: [
                          Button(
                            text: 'Gestionar ministerios',
                            onPressed: () {
                              Navigator.push(
                                context,
                                createFadeRoute(MinistryManage()),
                              );
                            },
                            size: Size(230, 45),
                          ),
                          const SizedBox(width: 15),
                          AddButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                createFadeRoute(CreateMinistry()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                350.0, // Ancho máximo de cada elemento
                            childAspectRatio:
                                2.3, // Proporción de aspecto (ancho/alto)
                            crossAxisSpacing: 20, // Espacio entre columnas
                            mainAxisSpacing: 20, // Espacio entre filas
                          ),
                      itemCount: ministries.length,
                      itemBuilder: (context, index) {
                        final ministry = ministries[index];
                        final memberCount = ministryProvider
                            .getMemberCountForMinistry(ministry.id);
                        return InkWell(
                          onTap: () {
                            // Acción de navegación
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MinistryMembers(ministry: ministry),
                              ),
                            );
                          },
                          child: _buildMinistryCard(
                            title: ministry.name,
                            details: ministry.details,
                            icon: Icons.group, // O un ícono dinámico
                            memberCount: memberCount,
                          ),
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

  // Widget de ejemplo para la tarjeta de ministerio
  Widget _buildMinistryCard({
    required String title,
    required String details,
    required IconData icon,
    required int memberCount,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,

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
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        details,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$memberCount Miembros',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
