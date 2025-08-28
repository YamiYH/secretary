import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../widgets/menu.dart';

// Definimos la clase Member para representar a cada miembro
class Member {
  final String name;
  final String territory;

  Member({required this.name, required this.territory});
}

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  // Lista de miembros de ejemplo
  final List<Member> _allMembers = [
    Member(name: 'Ethan Carter', territory: 'Territorio A'),
    Member(name: 'Olivia Bennett', territory: 'Territorio B'),
    Member(name: 'Noah Thompson', territory: 'Territorio A'),
    Member(name: 'Sophia Ramirez', territory: 'Territorio C'),
    Member(name: 'Liam Walker', territory: 'Territorio B'),
    Member(name: 'Ava Rodriguez', territory: 'Territorio C'),
    Member(name: 'Jackson Davis', territory: 'Territorio A'),
    Member(name: 'Isabella Lewis', territory: 'Territorio B'),
    Member(name: 'Carlos Garcia', territory: 'Territorio A'),
    Member(name: 'Maria Fernandez', territory: 'Territorio B'),
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
            member.territory.toLowerCase().contains(query);
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
        //mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Menu(),
          // Contenido principal de Servicios
          Expanded(
            child: Column(
              children: [
                // Barra de búsqueda
                Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText:
                                  'Buscar', // Texto de sugerencia en español
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                              ),
                              border: InputBorder
                                  .none, // Elimina el borde del TextField
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 14.0,
                              ),
                            ),
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    AddButton(
                      onPressed: () {},
                      text: 'Miembro',
                      size: Size(170, 45),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                // Lista de miembros
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(
                              0.1,
                            ), // Fondo azul suave
                            child: Text(
                              member.name
                                  .substring(0, 1)
                                  .toUpperCase(), // Inicial del nombre
                              style: TextStyle(
                                color: Colors.blue[800],
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
                            member.territory,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
