import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/create/create_ministry.dart';
import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../widgets/menu.dart';

class Ministries extends StatelessWidget {
  const Ministries({super.key});

  final List<Map<String, dynamic>> _groups = const [
    {
      'title': 'Misericordia',
      'subtitle': 'Personas vulnerables',
      'icon': Icons.group,
    },
    {
      'title': 'Ensancha',
      'subtitle': 'Personas de negocios',
      'icon': Icons.group,
    },
    {
      'title': 'Libres como el viento',
      'subtitle': 'Atencion a los presos',
      'icon': Icons.group,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Redes'),
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
                      const Text(
                        'Ministerios',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AddButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            createFadeRoute(CreateMinistry()),
                          );
                        },
                        text: 'Ministerio',
                        size: Size(160, 45),
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
                                2, // Proporción de aspecto (ancho/alto)
                            crossAxisSpacing: 20, // Espacio entre columnas
                            mainAxisSpacing: 20, // Espacio entre filas
                          ),
                      itemCount: _groups.length,
                      itemBuilder: (context, index) {
                        final group = _groups[index];
                        return _buildGroupCard(
                          group['title'],
                          group['subtitle'],
                          group['icon'],
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
  Widget _buildGroupCard(String title, String subtitle, IconData icon) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
