// lib/widgets/date.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  // 1. Hacemos el widget 'Stateless' de nuevo. No necesita estado propio,
  //    ya que la fecha seleccionada se gestiona en la pantalla principal (Attendance).
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DateWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  // 2. La función para mostrar el calendario se mueve aquí.
  //    Es una función privada del widget.
  Future<void> _selectDate(BuildContext context) async {
    // Obtenemos la fecha de hoy, ignorando la hora.
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final DateTime? picked = await showDatePicker(
      context: context,
      // Usa la fecha ya seleccionada como fecha inicial del calendario.
      initialDate: selectedDate,
      firstDate: DateTime(2020), // Un año razonable en el pasado.
      lastDate: DateTime(2100), // Un año razonable en el futuro.
      locale: const Locale(
        'es',
        'ES',
      ), // Asegura que el calendario esté en español.
      // --- LÓGICA CLAVE PARA DESHABILITAR FECHAS FUTURAS ---
      selectableDayPredicate: (DateTime day) {
        // Devuelve 'true' (seleccionable) solo si el día NO es posterior a hoy.
        return !day.isAfter(today);
      },
    );

    // Si el usuario seleccionó una fecha, llamamos al callback para notificar a la pantalla principal.
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. Formateamos la fecha para que se vea legible y amigable.
    //    Ejemplo: "15 de enero de 2026"
    final formattedDate = DateFormat.yMMMMd('es_ES').format(selectedDate);

    // 4. Usamos un ElevatedButton.icon que llama a nuestra función _selectDate.
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade400, width: 1.5),
        padding: EdgeInsets.all(20),
        elevation: 1,
      ),
      // Al presionar, se ejecuta la lógica para mostrar el calendario configurado.
      onPressed: () => _selectDate(context),
      icon: Icon(Icons.calendar_today, color: Colors.grey.shade700, size: 20),
      label: Text(
        formattedDate,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
