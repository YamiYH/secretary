import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/admin.dart';
import 'package:app/screens/attendance.dart';
import 'package:app/screens/dashboard.dart';
import 'package:app/screens/members.dart';
import 'package:app/screens/ministries.dart';
import 'package:app/screens/services.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../screens/networks.dart';
import '../screens/reports.dart';

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
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      // Se ajusta el ancho del Drawer para que no ocupe toda la pantalla en desktop
      width: isMobile ? screenWidth * 0.75 : screenWidth * 0.2,
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10),
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
            title: const Text('Inicio', style: TextStyle(color: Colors.black)),
            selected: _selectedIndex == 0,
            onTap: () {
              Navigator.push(context, createFadeRoute(Dashboard()));
              setState(() {
                _selectedIndex = 0;
              });
              if (isMobile) {
                Navigator.pop(context);
              }
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
              if (isMobile) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.people_alt_outlined, color: primaryColor),
            title: const Text(
              'Miembros',
              style: TextStyle(color: Colors.black),
            ),
            selected: _selectedIndex == 2,
            onTap: () {
              Navigator.push(context, createFadeRoute(Members()));
              setState(() {
                _selectedIndex = 2;
              });
              if (isMobile) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.how_to_reg_outlined, color: Colors.cyan),
            title: const Text('Asistencia'),
            selected: _selectedIndex == 3,
            onTap: () {
              Navigator.push(context, createFadeRoute(Attendance()));
              setState(() {
                _selectedIndex = 3;
              });
              if (isMobile) {
                Navigator.pop(context);
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.group, color: Colors.redAccent),
            title: const Text('Redes'),
            selected: _selectedIndex == 4,
            onTap: () {
              Navigator.push(context, createFadeRoute(Networks()));
              setState(() {
                _selectedIndex = 4;
              });
              if (isMobile) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.description_outlined,
              color: Colors.indigo,
            ),
            title: const Text('Ministerios'),
            selected: _selectedIndex == 5,
            onTap: () {
              Navigator.push(context, createFadeRoute(Ministries()));
              setState(() {
                _selectedIndex = 5;
              });
              if (isMobile) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.bar_chart_outlined,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text('Reportes'),
            selected:
                _selectedIndex == 6, // Cambiado a 5 para evitar duplicidad
            onTap: () {
              Navigator.push(context, createFadeRoute(Reports()));
              setState(() {
                _selectedIndex = 6; // Cambiado a 5
              });
              if (isMobile) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
              // Aquí podrías navegar a la pantalla de Reportes
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Administración'),
            selected: _selectedIndex == 7,
            onTap: () {
              Navigator.push(context, createFadeRoute(Admin()));
              setState(() {
                _selectedIndex = 7;
              });
              if (isMobile) {
                Navigator.pop(context); // Cierra el drawer en móvil
              }
            },
          ),
        ],
      ),
    );
  }
}
