import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/attendance.dart';
import 'package:app/screens/dashboard.dart';
import 'package:app/screens/members.dart';
import 'package:app/screens/services.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int _selectedIndex = 0; // Índice para el elemento seleccionado del menú

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      // Se ajusta el ancho del Drawer para que no ocupe toda la pantalla en desktop
      width: isDesktop ? screenWidth * 0.2 : screenWidth * 0.75,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red.shade200,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  'Usuario',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'Lider de celula',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.teal),
            title: const Text('Inicio'),
            selected: _selectedIndex == 0,
            onTap: () {
              Navigator.push(context, createFadeRoute(Dashboard()));
              setState(() {
                _selectedIndex = 0;
              });
              if (!isDesktop) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_outlined, color: primaryColor),
            title: const Text('Miembros'),
            selected: _selectedIndex == 0,
            onTap: () {
              Navigator.push(context, createFadeRoute(Members()));
              setState(() {
                _selectedIndex = 0;
              });
              if (!isDesktop) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
              // Aquí podrías navegar a la pantalla de Miembros
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.deepOrange,
            ),
            title: const Text('Servicios'),
            selected: _selectedIndex == 1,
            onTap: () {
              Navigator.push(context, createFadeRoute(Services()));
              setState(() {
                _selectedIndex = 1;
              });
              if (!isDesktop) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
              // Si ServicesScreen es la pantalla actual, no necesitas navegar.
              // Si es otra pantalla de servicios, descomenta y usa tu ruta:
              // Navigator.push(context, createFadeRoute(Services()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.how_to_reg_outlined, color: Colors.cyan),
            title: const Text('Asistencia'),
            selected: _selectedIndex == 2,
            onTap: () {
              Navigator.push(context, createFadeRoute(Attendance()));
              setState(() {
                _selectedIndex = 2;
              });
              if (!isDesktop) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
              // Aquí podrías navegar a la pantalla de Asistencia
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.description_outlined,
              color: Colors.indigo,
            ),
            title: const Text('Ministerios'),
            selected: _selectedIndex == 4,
            onTap: () {
              setState(() {
                _selectedIndex = 4;
              });
              if (!isDesktop) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
              // Aquí podrías navegar a la pantalla de Ministerios
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.bar_chart_outlined,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text('Reportes'),
            selected:
                _selectedIndex == 5, // Cambiado a 5 para evitar duplicidad
            onTap: () {
              setState(() {
                _selectedIndex = 5; // Cambiado a 5
              });
              if (!isDesktop) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
              // Aquí podrías navegar a la pantalla de Reportes
            },
          ),
        ],
      ),
    );
  }
}
