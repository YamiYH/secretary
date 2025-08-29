import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/counter.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../widgets/menu.dart';
import '../widgets/search_text_field.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  // Lista de miembros de ejemplo
  final List _allMembers = [
    'Ethan Carter',
    'Olivia Bennett',
    'Noah Thompson',
    'Sophia Ramirez',
    'Liam Walker',
    'Ava Rodriguez',
    'Jackson Davis',
  ];

  List _filteredMembers = [];
  final TextEditingController _searchController = TextEditingController();

  int _guestCount = 0; // Estado para el contador de visitas
  int _pastoralVisitCount = 0; // Estado para el contador de visitas pastorales
  bool value = false;

  @override
  void initState() {
    super.initState();
    _filteredMembers = _allMembers;
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
        return member.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Miembros'),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: Row(
        children: [
          // Muestra el menú solo en modo de escritorio
          if (!isMobile) Menu(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                // Barra de búsqueda
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      //SizedBox(width: 20),
                      SearchTextField(controller: _searchController),
                      SizedBox(width: 40),
                      Flexible(
                        child: Counter(
                          label: 'Visitas',
                          onCountChanged: (count) {
                            setState(() {
                              _guestCount = count;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 40),
                      Flexible(
                        child: Counter(
                          label: 'Visitas Pastorales',
                          onCountChanged: (count) {
                            setState(() {
                              _pastoralVisitCount = count;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 40),
                      AddButton(
                        onPressed: () {},
                        text: 'Miembro',
                        size: Size(160, 45),
                      ),
                      SizedBox(width: 20),
                      Button(
                        text: 'Guardar',
                        onPressed: () {},
                        size: Size(160, 45),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
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
                            backgroundColor: Colors.red.withOpacity(0.1),
                            child: Text(
                              member.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: Colors.redAccent[200],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            member,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Checkbox(
                            checkColor: Colors.grey,
                            value: value,
                            onChanged: (value) {},
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
