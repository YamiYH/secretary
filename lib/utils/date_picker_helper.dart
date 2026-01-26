// lib/utils/date_picker_helper.dart

import 'package:flutter/material.dart';

// Esta función envuelve la llamada a showDatePicker con nuestra lógica personalizada.
Future<DateTime?> showConfiguredDatePicker({
  required BuildContext context,
  required DateTime initialDate,
}) {
  // Obtenemos la fecha de hoy, ignorando la hora, minutos y segundos.
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2020), // Un año razonable en el pasado
    lastDate: DateTime(2100), // Un año razonable en el futuro
    // --- ¡AQUÍ ESTÁ LA LÓGICA CLAVE! ---
    // Esta función decide qué días son seleccionables.
    // Recibe un 'day' y debe devolver 'true' si es seleccionable, 'false' si no.
    selectableDayPredicate: (DateTime day) {
      // La condición es simple:
      // El día es seleccionable si NO es posterior al día de hoy.
      // 'isAfter(today)' devuelve true si 'day' es mañana o después.
      // Por lo tanto, negamos el resultado.
      return !day.isAfter(today);
    },
  );
}
