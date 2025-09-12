// En tu archivo 'admin_screen.dart'

import 'package:app/colors.dart';
import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/roles.dart';
import 'package:app/screens/settings.dart';
import 'package:app/screens/users.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/menu.dart';
import 'package:flutter/material.dart';

import 'logs.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Administración'),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Menu(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return isMobile
                    ? _buildMobileLayout(context)
                    : _buildWebLayout(context, isMobile);
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Layout para Móvil (una columna) ---
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildCard(context, Icons.people, 'Usuarios'),
          _buildCard(context, Icons.shield, 'Roles'),
          _buildCard(context, Icons.history, 'Logs'),
          _buildCard(context, Icons.settings, 'Configuración'),
        ],
      ),
    );
  }

  // --- Layout para Web (tres columnas) ---
  Widget _buildWebLayout(BuildContext context, bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: GridView.count(
        crossAxisCount: isMobile ? 1 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.7,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildCard(context, Icons.people, 'Usuarios'),
          _buildCard(context, Icons.shield, 'Roles'),
          _buildCard(context, Icons.history, 'Logs'),
          _buildCard(context, Icons.settings, 'Configuración'),
        ],
      ),
    );
  }

  // --- Widget Común para las Tarjetas ---
  Widget _buildCard(BuildContext context, IconData icon, String title) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: InkWell(
        onTap: () {
          // Lógica para la navegación
          switch (title) {
            case 'Usuarios':
              Navigator.push(context, createFadeRoute(const Users()));
              break;
            case 'Roles':
              Navigator.push(context, createFadeRoute(const Roles()));
              break;
            case 'Logs':
              Navigator.push(context, createFadeRoute(const Logs()));
              break;
            case 'Configuración':
              Navigator.push(context, createFadeRoute(const Settings()));
              break;
          }
        },
        borderRadius: BorderRadius.circular(15.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50.0, color: Colors.blue),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
