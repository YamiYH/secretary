import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/create/create_member.dart';
import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../widgets/menu.dart';
import '../widgets/search_text_field.dart';

// Definimos la clase Member para representar a cada miembro
class Member {
  final String name;
  final String groups;

  Member({required this.name, required this.groups});
}

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  // Lista de miembros de ejemplo
  final List<Member> _allMembers = [
    Member(name: 'Ethan Carter', groups: 'Jóvenes'),
    Member(name: 'Olivia Bennett', groups: 'Mujeres'),
    Member(name: 'Noah Thompson', groups: 'Hombres'),
    Member(name: 'Sophia Ramirez', groups: 'Jóvenes'),
    Member(name: 'Liam Walker', groups: 'Hombres'),
    Member(name: 'Ava Rodriguez', groups: 'Jóvenes'),
    Member(name: 'Jackson Davis', groups: 'Hombres'),
    Member(name: 'Isabella Lewis', groups: '3ra Edad'),
    Member(name: 'Carlos Garcia', groups: 'Jóvenes'),
    Member(name: 'Maria Fernandez', groups: '3ra Edad'),
  ];

  List<Member> _filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMembers = _allMembers; // Inicialmente, muestra todos los miembros
    _searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMembers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterMembers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        return member.name.toLowerCase().contains(query) ||
            member.groups.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    final Widget membersContent = _buildMembers(context, isMobile);

    // 🚀 CLAVE: Definir el widget leading (el botón de la izquierda)
    Widget? leadingWidget;
    if (isMobile) {
      // Usamos Builder para obtener un contexto capaz de encontrar el Scaffold
      leadingWidget = Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ), // Usamos el color de tu AppBar
            onPressed: () {
              // Abrir el Drawer usando el contexto del Builder
              Scaffold.of(context).openDrawer();
            },
          );
        },
      );
    }
    // Si no es móvil, Flutter mostrará automáticamente la flecha de atrás si es necesario,
    // o nada si es la pantalla raíz.
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Miembros', isDrawerEnabled: isMobile),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: isMobile
          ? SingleChildScrollView(child: _buildMembers(context, isMobile))
          : Row(
              children: [
                Menu(),
                Expanded(child: _buildMembers(context, isMobile)),
              ],
            ),
    );
  }

  Column _buildMembers(BuildContext context, isMobile) {
    return Column(
      children: [
        SizedBox(height: 20),
        // Barra de búsqueda
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //if (!isMobile) SizedBox(width: 20),
              Expanded(child: SearchTextField(controller: _searchController)),
              SizedBox(width: 20),
              AddButton(
                onPressed: () {
                  Navigator.push(context, createFadeRoute(CreateMember()));
                },
              ),
              //SizedBox(width: 20),
            ],
          ),
        ),
        SizedBox(height: 30),
        // Lista de miembros
        Expanded(child: _buildMemberList(isMobile)),
      ],
    );
  }

  Padding _buildMemberList(isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2.5,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListView.builder(
          shrinkWrap: isMobile ? true : false,
          physics: isMobile ? const NeverScrollableScrollPhysics() : null,
          padding: const EdgeInsets.all(16.0),
          itemCount: _filteredMembers.length,
          itemBuilder: (context, index) {
            final member = _filteredMembers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  child: Text(
                    member.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: Colors.redAccent[200],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  member.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  member.groups,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 18,
                ),
                onTap: () {
                  // Acción al tocar un miembro (ej. ir a su perfil)
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
