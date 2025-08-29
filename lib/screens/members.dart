import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

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
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo gris claro
      appBar: CustomAppBar(title: 'Miembros'),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: Row(
        children: [
          Menu(),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 20),
                // Barra de búsqueda
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20),
                    SearchTextField(controller: _searchController),
                    SizedBox(width: 10),
                    AddButton(
                      onPressed: () {},
                      text: 'Miembro',
                      size: Size(170, 45),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 30),
                // Lista de miembros
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Esquinas redondeadas
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
