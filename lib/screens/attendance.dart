import 'package:app/widgets/button.dart';
import 'package:app/widgets/counter.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/date.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../widgets/menu.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final DateTime? selectedDate = DateTime.now();

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
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Asistencia'),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: Row(
        children: [
          if (!isMobile) Menu(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: isMobile
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildDateWidget(),
                                SizedBox(width: 20),
                                _buildButton(),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildVisitas(),
                                SizedBox(width: 50),
                                _buildPastorales(),
                              ],
                            ),
                          ],
                        )
                      : Wrap(
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            //SizedBox(width: 20),
                            _buildDateWidget(),
                            SizedBox(width: 40),
                            _buildVisitas(),
                            SizedBox(width: 40),
                            _buildPastorales(),
                            SizedBox(width: 40),
                            _buildButton(),
                          ],
                        ),
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
                        padding: const EdgeInsets.all(20),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Flexible _buildPastorales() {
    return Flexible(
      child: Counter(
        label: 'Visitas Pastorales',
        onCountChanged: (count) {
          setState(() {
            _pastoralVisitCount = count;
          });
        },
      ),
    );
  }

  Button _buildButton() {
    return Button(text: 'Guardar', onPressed: () {}, size: Size(160, 45));
  }

  Flexible _buildVisitas() {
    return Flexible(
      child: Counter(
        label: 'Visitas',
        onCountChanged: (count) {
          setState(() {
            _guestCount = count;
          });
        },
      ),
    );
  }

  DateWidget _buildDateWidget() {
    return DateWidget(
      selectedDate: DateTime.now(),
      onDateSelected: (date) {
        setState(() {});
      },
    );
  }
}
