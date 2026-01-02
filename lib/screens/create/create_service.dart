import 'package:app/models/service_model.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/small_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../colors.dart';
import '../../providers/service_provider.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/menu.dart';

class CreateService extends StatefulWidget {
  const CreateService({super.key});

  @override
  State<CreateService> createState() => _CreateServiceState();
}

// 🚀 NUEVA CLASE: Para almacenar los datos del evento
class ServiceEvent {
  final String title;
  final DateTime date;
  final TimeOfDay time;
  final String preacher;
  final String worshipMinister;

  ServiceEvent({
    required this.title,
    required this.date,
    required this.time,
    required this.preacher,
    required this.worshipMinister,
  });
}

class _CreateServiceState extends State<CreateService> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedStartTime;

  // Se usan para seleccionar un rango de días, si no se usan, se dejan como null
  DateTime? _rangeStartDay;
  DateTime? _rangeEndDay;

  // Define el formato inicial del calendario (ej: Mes, Semana)
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStartDay = null; // Reinicia el rango si se selecciona un día
        _rangeEndDay = null;
      });
    }
    // Asegúrate de que tu lógica para abrir el diálogo de creación esté aquí:
    _showServiceForm(context, selectedDay);
  }

  List<ServiceModel> _getEventsForDay(DateTime day) {
    // 🚀 Leemos la lista del provider para el calendario
    return Provider.of<ServiceProvider>(
      context,
      listen: false,
    ).getEventsForDay(day);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    // final locale = Localizations.localeOf(context);
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
              child: isMobile
                  ? Column(
                      children: [
                        _buildCalendar(isMobile, context),
                        const SizedBox(width: 50, height: 32),
                        _buildServices(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildCalendar(isMobile, context)),
                        const SizedBox(width: 50, height: 32),
                        Expanded(child: _buildServices()),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildServices() {
    final today = DateTime.now();
    final todayEvents = _getEventsForDay(today);
    return Column(
      children: [
        const Text(
          'Hoy',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        if (todayEvents.isEmpty)
          Text(
            'No hay servicios programados para hoy, ${today.day}/${today.month}.',
            style: TextStyle(color: Colors.grey[600]),
          ),

        ...todayEvents.map((event) {
          final formattedTime =
              '${event.time.hourOfPeriod}:${event.time.minute.toString().padLeft(2, '0')} ${event.time.period == DayPeriod.am ? 'A.M.' : 'P.M.'}';
          return _buildServiceListItem(
            Icons.schedule,
            event.title,
            formattedTime,
          );
        }).toList(),
      ],
    );
  }

  Column _buildCalendar(bool isMobile, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Calendario',
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
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
            child: TableCalendar<ServiceModel>(
              locale: 'es_ES',
              eventLoader: _getEventsForDay,
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              rangeStartDay: _rangeStartDay,
              rangeEndDay: _rangeEndDay,
              calendarFormat: _calendarFormat,
              onDaySelected: _onDaySelected,

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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isNotEmpty) {
                    final tooltipMessage = (events)
                        .map((e) {
                          final formattedTime =
                              '${e.time.hourOfPeriod}:${e.time.minute.toString().padLeft(2, '0')} ${e.time.period == DayPeriod.am ? 'A.M.' : 'P.M.'}';
                          return '${e.title} a las $formattedTime, Predica: ${e.preacher} y ministra: ${e.worshipMinister}';
                        })
                        .join('\n');

                    // Devolvemos el marcador (el punto rojo) envuelto en un Tooltip
                    return Tooltip(
                      message: tooltipMessage,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red[700],
                        ),
                      ),
                    );
                  }
                  return null; // Si no hay eventos, no muestra nada
                },
              ),
            ),
          ),
        ),
      ],
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

  // En tu archivo create_service.dart, dentro de _CreateServiceState

  Future<TimeOfDay?> _showCustomTimePickerDialog(
    BuildContext context,
    TimeOfDay? initialTime,
  ) async {
    // Inicializamos la hora en formato 12 horas.
    int selectedHour = initialTime?.hourOfPeriod ?? 12;
    if (selectedHour == 0) selectedHour = 12; // 0:00 se mapea a 12 AM
    int selectedMinute = initialTime?.minute ?? 0;
    String selectedPeriod =
        (initialTime?.period ?? DayPeriod.am) == DayPeriod.am ? 'AM' : 'PM';

    return await showDialog<TimeOfDay>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Seleccionar hora'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Dropdown para la Hora (1 a 12)
                  DropdownButton<int>(
                    value: selectedHour,
                    items: List.generate(12, (i) => i + 1).map((h) {
                      return DropdownMenuItem(
                        value: h,
                        child: Text(h.toString().padLeft(2, '0')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => selectedHour = value);
                    },
                  ),
                  const Text(
                    ':',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Dropdown para el Minuto (0 a 59)
                  DropdownButton<int>(
                    value: selectedMinute,
                    items: List.generate(60, (i) => i).map((m) {
                      return DropdownMenuItem(
                        value: m,
                        child: Text(m.toString().padLeft(2, '0')),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) setState(() => selectedMinute = value);
                    },
                  ),
                  // Botones para AM/PM
                  ToggleButtons(
                    isSelected: [
                      selectedPeriod == 'AM',
                      selectedPeriod == 'PM',
                    ],
                    onPressed: (index) {
                      setState(() => selectedPeriod = index == 0 ? 'AM' : 'PM');
                    },
                    children: const [Text('AM'), Text('PM')],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(null),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    // Lógica para convertir el formato 12h a 24h (TimeOfDay)
                    int hour24 = selectedHour;
                    if (selectedPeriod == 'PM' && selectedHour != 12) {
                      hour24 += 12;
                    }
                    if (selectedPeriod == 'AM' && selectedHour == 12) {
                      hour24 = 0; // Medianoche
                    }
                    final resultTime = TimeOfDay(
                      hour: hour24,
                      minute: selectedMinute,
                    );
                    Navigator.of(dialogContext).pop(resultTime);
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Muestra la ventana de diálogo para añadir el servicio
  Future<void> _showServiceForm(
    BuildContext context,
    DateTime selectedDay,
  ) async {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController predicadorController = TextEditingController();
    final TextEditingController alabanzaController = TextEditingController();
    // 🚀 2. Variable local para manejar el estado de la hora DENTRO del diálogo
    TimeOfDay? dialogSelectedTime = _selectedStartTime;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Formulario dentro del diálogo
        return StatefulBuilder(
          builder: (context, dialogSetState) {
            return AlertDialog(
              title: Text(
                'Nuevo Servicio el ${selectedDay.day}/${selectedDay.month}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 55,
                      child: InkWell(
                        onTap: () async {
                          // 1. Abrimos el selector nativo de hora
                          final TimeOfDay? selectedTime =
                              await _showCustomTimePickerDialog(
                                context,
                                dialogSelectedTime,
                              );

                          if (selectedTime != null) {
                            // 2. Usamos dialogSetState para actualizar la variable y la vista
                            dialogSetState(() {
                              dialogSelectedTime = selectedTime;
                            });
                            // NOTA: Ya no necesitamos el widget TimePicker.
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 3. MOSTRAMOS EL TEXTO DE FORMA REACTIVA
                              Text(
                                dialogSelectedTime != null
                                    ? 'Hora de inicio: ${dialogSelectedTime!.hourOfPeriod}:${dialogSelectedTime!.minute.toString().padLeft(2, '0')} ${dialogSelectedTime!.period == DayPeriod.am ? 'A.M.' : 'P.M.'}'
                                    : 'Seleccionar hora de inicio',
                                style: TextStyle(
                                  color: dialogSelectedTime != null
                                      ? Colors.black87
                                      : Colors.grey[700],
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(Icons.access_time),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: titleController,
                      labelText: 'Nombre del Servicio',
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: predicadorController,
                      labelText: 'Predicador(a)',
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: alabanzaController,
                      labelText: 'Ministro de Alabanza',
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
                    // 🚀 5. Lógica para guardar los datos
                    final String title = titleController.text;
                    final String predicador = predicadorController.text;
                    final String alabanza = alabanzaController.text;

                    // Verificamos que se hayan llenado los campos (puedes añadir validación)
                    if (dialogSelectedTime != null &&
                        title.isNotEmpty &&
                        predicador.isNotEmpty &&
                        alabanza.isNotEmpty) {
                      // 🚀 1. CREAMOS EL NUEVO EVENTO
                      final newService = ServiceModel(
                        title: title,
                        date: selectedDay,
                        time: dialogSelectedTime!,
                        preacher: predicador,
                        worshipMinister: alabanza,
                      );

                      Provider.of<ServiceProvider>(
                        context,
                        listen: false,
                      ).addService(newService);
                      Navigator.pop(context);
                      setState(() {});
                    } else {
                      // Opcional: Muestra un mensaje si faltan datos
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, completa todos los campos'),
                        ),
                      );
                    }
                  },
                  text: 'Guardar',
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(() {
      // 🚀 6. Limpiamos los controladores para evitar fugas de memoria
      predicadorController.dispose();
      alabanzaController.dispose();
    });
  }
}
