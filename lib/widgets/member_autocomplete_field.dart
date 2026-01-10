// lib/widgets/member_autocomplete_field.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/member_model.dart'; // Asegúrate de que la ruta a tu modelo de miembro sea correcta
import '../providers/member_provider.dart'; // Asegúrate de que la ruta a tu provider de miembro sea correcta

class MemberAutocompleteField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final Function(Member?)
  onMemberSelected; // Callback para saber si se eligió un miembro

  const MemberAutocompleteField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.onMemberSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenemos la lista completa de miembros una sola vez
    final List<Member> allMembers = Provider.of<MemberProvider>(
      context,
      listen: false,
    ).members;

    return Autocomplete<Member>(
      // 1. Define cómo se muestra la opción en la lista desplegable
      displayStringForOption: (Member option) =>
          '${option.name} ${option.lastName}',

      // 2. La función que filtra las opciones a medida que el usuario escribe
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<
            Member
          >.empty(); // No mostrar nada si el campo está vacío
        }
        // Filtra la lista de miembros basándose en el texto introducido (ignorando mayúsculas/minúsculas)
        return allMembers.where((Member member) {
          final fullName = '${member.name} ${member.lastName}'.toLowerCase();
          return fullName.contains(textEditingValue.text.toLowerCase());
        });
      },

      // 3. Lo que sucede cuando el usuario selecciona una opción de la lista
      onSelected: (Member selection) {
        // Actualiza el texto del controlador con el nombre completo del miembro seleccionado
        controller.text = '${selection.name} ${selection.lastName}';
        // Llama al callback para notificar que se ha seleccionado un miembro real
        onMemberSelected(selection);
      },

      // 4. El constructor del campo de texto que el usuario ve
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Asignamos nuestro controlador externo al del Autocomplete
            // Esto es un pequeño truco para que funcione con nuestro `TextEditingController`
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (fieldController.text != controller.text) {
                fieldController.text = controller.text;
              }
            });

            return TextFormField(
              controller: fieldController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(
                labelText: labelText,
                border: const OutlineInputBorder(),
              ),
              onChanged: (text) {
                // Si el usuario modifica el texto, asumimos que ya no es un miembro seleccionado
                // y pasamos null al callback.
                controller.text = text;
                onMemberSelected(null);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Este campo no puede estar vacío.';
                }
                return null;
              },
            );
          },

      // 5. El constructor para cada opción en la lista desplegable
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<Member> onSelected,
            Iterable<Member> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4.0,
                child: SizedBox(
                  width: 300, // Ajusta el ancho según tu diseño
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Member option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: ListTile(
                          title: Text('${option.name} ${option.lastName}'),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
    );
  }
}
