import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  final String label;
  final Function(int) onCountChanged; // Callback para notificar el cambio

  const Counter({super.key, required this.label, required this.onCountChanged});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
      widget.onCountChanged(_count); // Notificar al padre del cambio
    });
  }

  void _decrement() {
    setState(() {
      if (_count > 0) {
        _count--;
        widget.onCountChanged(_count); // Notificar al padre del cambio
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 36, // Altura fija para el control del contador
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 20),
                onPressed: _decrement,
                splashRadius: 20, // Reduce el radio del splash
                padding: EdgeInsets.zero, // Elimina padding extra
                constraints:
                    const BoxConstraints(), // Elimina restricciones de tamaño por defecto
              ),
              SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  '$_count',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 5),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: _increment,
                splashRadius: 20, // Reduce el radio del splash
                padding: EdgeInsets.zero, // Elimina padding extra
                constraints:
                    const BoxConstraints(), // Elimina restricciones de tamaño por defecto
              ),
            ],
          ),
        ),
      ],
    );
  }
}
