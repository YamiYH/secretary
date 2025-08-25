import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;
  final double height;
  final double? width;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 5.0,
    this.height = 50.0,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Si se proporciona un ancho, úsalo; de lo contrario, ocupa el ancho máximo.
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor:
              textColor ?? Colors.white, // Color del texto (por defecto blanco)
          backgroundColor:
              backgroundColor ??
              Colors.blueAccent.shade700, // Color de fondo (por defecto azul)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ), // Usa el radio de borde personalizado
          ),
          elevation: 5, // Sombra para el botón
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
