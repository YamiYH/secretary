import 'package:app/widgets/button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class CreateMinistry extends StatelessWidget {
  const CreateMinistry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Crear nuevo ministerio'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(70.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ), // Limita el ancho en pantallas grandes
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detalles del Ministerio',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre del Ministerio',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      size: Size(130, 45),
                      text: 'Guardar',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
