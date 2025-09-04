import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/small_button.dart';
import 'package:app/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../colors.dart';
import '../../widgets/menu.dart';

class CreateService extends StatefulWidget {
  const CreateService({super.key});

  @override
  State<CreateService> createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedStartTime;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Crear servicio'),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const SizedBox(child: Menu()),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: const Text(
                            'Calendario',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TableCalendar(
                              locale: 'es_ES',
                              firstDay: DateTime.now(),
                              lastDay: DateTime.utc(2030, 12, 31),
                              focusedDay: _focusedDay,
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                                _showServiceForm(context, selectedDay);
                              },
                              calendarFormat: CalendarFormat.month,
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                              ),
                              calendarStyle: CalendarStyle(
                                selectedDecoration: BoxDecoration(
                                  color: primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                todayDecoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 50, height: 32),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          'Hoy',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildServiceListItem(
                          Icons.church,
                          'Celebración',
                          '9:00 AM',
                        ),
                        _buildServiceListItem(
                          Icons.people,
                          'Adoración',
                          '6:00 PM',
                        ),
                        _buildServiceListItem(
                          Icons.menu_book,
                          'Células',
                          '7:00 PM',
                        ),
                      ],
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

  // Widget para las tarjetas de servicio
  Widget _buildServiceListItem(IconData icon, String title, String time) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, size: 35, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(time, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }

  // Muestra la ventana de diálogo para añadir el servicio
  void _showServiceForm(BuildContext context, DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Formulario dentro del diálogo
        return AlertDialog(
          title: Text(
            'Nuevo Servicio el ${selectedDay.day}/${selectedDay.month}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Detalles del Servicio:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                TimePicker(
                  onTimeSelected: (time) {
                    setState(() {
                      _selectedStartTime = time;
                    });
                  },
                  initialTime: _selectedStartTime,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Predicador(a)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ministro de Alabanza',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SmallButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Guardar',
            ),
          ],
        );
      },
    );
  }
}
