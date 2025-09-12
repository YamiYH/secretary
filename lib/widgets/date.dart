import 'package:flutter/material.dart';

class DateWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DateWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<DateWidget> createState() => _DateWidgetState();
}

class _DateWidgetState extends State<DateWidget> {
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      width: isMobile ? MediaQuery.of(context).size.width * 0.40 : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Selector de Fecha
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(160, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.green, width: 2),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 20,
                vertical: isMobile ? 8 : 12,
              ),
            ),
            onPressed: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 90)),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData(
                      primaryColor: Colors.green,
                      colorScheme: ColorScheme.light(primary: Colors.blue),
                      textTheme: TextTheme(
                        headlineMedium: TextStyle(fontSize: 16),
                        bodyLarge: TextStyle(fontSize: 14),
                        bodyMedium: TextStyle(fontSize: 12),
                      ),
                      dialogTheme: DialogThemeData(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedDate != null) {
                widget.onDateSelected(pickedDate);
              }
            },
            icon: Icon(Icons.calendar_today, color: Colors.green),
            label: Text(
              widget.selectedDate == null
                  ? 'Seleccionar Fecha'
                  : '${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
