import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../models/attendance_record_model.dart';
import '../models/log_model.dart';
import '../models/member_model.dart';
import '../providers/attendance_provider.dart';
import '../providers/log_provider.dart';
import '../providers/member_provider.dart';
import '../widgets/button.dart';
import '../widgets/counter.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/date.dart';
import '../widgets/menu.dart';
import '../widgets/search_text_field.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  // --- ESTADO DE LA PANTALLA ---
  DateTime _selectedDate = DateTime.now();
  int _guestCount = 0;
  int _pastoralVisitCount = 0;
  // Set para almacenar los IDs de los miembros marcados como presentes
  final Set<String> _presentMemberIds = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cargar datos existentes si hay para la fecha seleccionada
    _loadRecordForDate(_selectedDate);
  }

  void _loadRecordForDate(DateTime date) {
    final attendanceProvider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );
    final record = attendanceProvider.getRecordForDate(date);

    setState(() {
      if (record != null) {
        // Si existe un registro, cargamos sus datos en el estado de la UI
        _guestCount = record.guestCount;
        _pastoralVisitCount = record.pastoralVisitCount;
        _presentMemberIds.clear();
        _presentMemberIds.addAll(record.presentMemberIds);
      } else {
        // Si no hay registro, reseteamos el estado
        _guestCount = 0;
        _pastoralVisitCount = 0;
        _presentMemberIds.clear();
      }
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _loadRecordForDate(date);
  }

  void _saveAttendance() {
    final attendanceProvider = Provider.of<AttendanceProvider>(
      context,
      listen: false,
    );
    final logProvider = Provider.of<LogProvider>(context, listen: false);
    final dateId =
        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

    final newRecord = AttendanceRecord(
      id: dateId,
      date: _selectedDate,
      guestCount: _guestCount,
      pastoralVisitCount: _pastoralVisitCount,
      presentMemberIds: Set.from(
        _presentMemberIds,
      ), // Creamos una copia del Set
    );

    attendanceProvider.saveRecord(newRecord);

    logProvider.addLog(
      userName: 'Admin',
      action: LogAction.create, // O update si el registro ya existía
      entity: LogEntity.report, // Podrías crear un LogEntity.attendance
      details:
          'Se guardó la asistencia para la fecha: $dateId. Asistentes: ${_presentMemberIds.length}, Visitas: $_guestCount.',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Asistencia guardada correctamente.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    // Obtenemos los miembros del MemberProvider
    final memberProvider = Provider.of<MemberProvider>(context);
    final List<Member> members = memberProvider.filteredMembers;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Asistencia', isDrawerEnabled: isMobile),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: Row(
        children: [
          if (!isMobile) Menu(),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // --- WIDGETS DE CONTROL SUPERIORES ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: isMobile
                      ? _buildMobileControls()
                      : _buildWebControls(),
                ),
                const SizedBox(height: 20),
                // --- BARRA DE BÚSQUEDA ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: SearchTextField(
                    onChanged: (query) => memberProvider.search(query),
                  ),
                ),
                const SizedBox(height: 20),
                // --- LISTA DE MIEMBROS ---
                Expanded(child: _buildMemberList(members)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- MÉTODOS BUILD REFACTORIZADOS ---

  Widget _buildMobileControls() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DateWidget(
              selectedDate: _selectedDate,
              onDateSelected: _onDateSelected,
            ),
            const SizedBox(width: 20),
            Button(
              text: 'Guardar',
              onPressed: _saveAttendance,
              size: const Size(160, 45),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Counter(
              label: 'Visitas',
              initialValue: _guestCount,
              onCountChanged: (count) => _guestCount = count,
            ),
            Counter(
              label: 'Visitas Pastorales',
              initialValue: _pastoralVisitCount,
              onCountChanged: (count) => _pastoralVisitCount = count,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWebControls() {
    return Wrap(
      spacing: 40,
      runSpacing: 20,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        DateWidget(
          selectedDate: _selectedDate,
          onDateSelected: _onDateSelected,
        ),
        Counter(
          label: 'Visitas',
          initialValue: _guestCount,
          onCountChanged: (count) => _guestCount = count,
        ),
        Counter(
          label: 'Visitas Pastorales',
          initialValue: _pastoralVisitCount,
          onCountChanged: (count) => _pastoralVisitCount = count,
        ),
        Button(
          text: 'Guardar',
          onPressed: _saveAttendance,
          size: const Size(160, 45),
        ),
      ],
    );
  }

  Widget _buildMemberList(List<Member> members) {
    if (members.isEmpty) {
      return const Center(child: Text('No se encontraron miembros.'));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
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
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            final bool isPresent = _presentMemberIds.contains(member.id);

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isPresent
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                child: Text(
                  member.name.isNotEmpty
                      ? member.name.substring(0, 1).toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: isPresent ? Colors.green : Colors.redAccent[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text('${member.name} ${member.lastName}'),
              trailing: Checkbox(
                value: isPresent,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _presentMemberIds.add(member.id);
                    } else {
                      _presentMemberIds.remove(member.id);
                    }
                  });
                },
              ),
              onTap: () {
                setState(() {
                  if (isPresent) {
                    _presentMemberIds.remove(member.id);
                  } else {
                    _presentMemberIds.add(member.id);
                  }
                });
              },
            );
          },
        ),
      ),
    );
  }
}
