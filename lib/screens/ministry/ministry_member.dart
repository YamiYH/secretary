// lib/screens/ministry_members_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../colors.dart';
import '../../models/member_model.dart';
import '../../models/ministry_model.dart';
import '../../providers/member_provider.dart'; // Necesitas un MemberProvider
import '../../providers/ministry_provider.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/small_button.dart';

class MinistryMembers extends StatelessWidget {
  final MinistryModel ministry;

  const MinistryMembers({Key? key, required this.ministry}) : super(key: key);

  // Diálogo de confirmación para eliminar
  void _showDeleteConfirmationDialog(BuildContext context, Member member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Quitar a ${member.name} ${member.lastName} del ministerio "${ministry.name}"?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Quitar'),
            onPressed: () {
              // Llama al provider para quitar al miembro
              Provider.of<MinistryProvider>(
                context,
                listen: false,
              ).removeMemberFromMinistry(ministry.id, member.id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Diálogo para agregar miembro con Autocomplete
  void _showAddMemberDialog(BuildContext context, List<Member> allMembers) {
    showDialog(
      context: context,
      builder: (ctx) {
        Member? selectedMember; // Para guardar el miembro seleccionado

        return AlertDialog(
          title: Text('Agregar Miembro a "${ministry.name}"'),
          content: Autocomplete<Member>(
            // Función que construye las opciones a mostrar
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<Member>.empty();
              }
              return allMembers.where((member) {
                final fullName = '${member.name} ${member.lastName}'
                    .toLowerCase();
                return fullName.contains(textEditingValue.text.toLowerCase());
              });
            },
            // Función que muestra el nombre del miembro en la lista de sugerencias
            displayStringForOption: (Member option) =>
                '${option.name} ${option.lastName}',
            // Cuando un miembro es seleccionado
            onSelected: (Member selection) {
              selectedMember = selection;
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Buscar miembro...',
                    ),
                  );
                },
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            SmallButton(
              text: 'Agregar',
              onPressed: () {
                if (selectedMember != null) {
                  // Llama al provider para agregar al miembro
                  Provider.of<MinistryProvider>(
                    context,
                    listen: false,
                  ).addMemberToMinistry(ministry.id, selectedMember!.id);
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Observamos ambos providers
    final ministryProvider = context.watch<MinistryProvider>();
    final memberProvider = context
        .watch<MemberProvider>(); // Asumo que tienes un MemberProvider

    // Obtenemos los IDs de los miembros de este ministerio
    final memberIds = ministryProvider.getMemberIdsForMinistry(ministry.id);

    // Obtenemos los objetos MemberModel completos a partir de los IDs
    final members = memberProvider.getMembersByIds(
      memberIds,
    ); // Necesitarás este método en MemberProvider

    // Obtenemos todos los miembros para el Autocomplete
    final allMembers = memberProvider.members;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Miembros de ${ministry.name}'),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _showAddMemberDialog(context, allMembers),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: members.isEmpty
          ? const Center(child: Text('No hay miembros en este ministerio.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(member.name[0])),
                    title: Text('${member.name} ${member.lastName}'),
                    subtitle: Text(member.phone), // O cualquier otro dato
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _showDeleteConfirmationDialog(context, member),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
