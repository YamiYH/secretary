import 'package:app/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/service_type_model.dart';
import '../../providers/service_type_provider.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/showDeleteConfirmationDialog.dart';
import '../../widgets/small_button.dart';

class ManageServiceTypesScreen extends StatelessWidget {
  const ManageServiceTypesScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuevo Nombre de Servicio'),
        content: CustomTextFormField(
          controller: controller,
          labelText: 'Nombre (ej. "Servicio de Damas")',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          SmallButton(
            text: 'Guardar',
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<ServiceTypeProvider>(
                  context,
                  listen: false,
                ).addServiceType(controller.text);
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ServiceType typeToEdit) {
    final controller = TextEditingController(text: typeToEdit.name);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Editar Nombre de Servicio'),
        content: CustomTextFormField(
          controller: controller,
          labelText: 'Nombre',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          SmallButton(
            text: 'Actualizar',
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<ServiceTypeProvider>(
                  context,
                  listen: false,
                ).updateServiceType(typeToEdit.id, controller.text);
                Navigator.of(ctx).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceTypeProvider>();
    final types = provider.serviceTypes;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Gestionar Nombres de Servicios'),

      // --- ESTRUCTURA DEL BODY SIMPLIFICADA Y CORREGIDA ---
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: types.isEmpty
              ? const Center(
                  child: Text(
                    'No hay nombres de servicio.\nPresiona el botón (+) para añadir el primero.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  // El padding se aplica directamente al ListView, lo cual es más eficiente.
                  padding: const EdgeInsets.symmetric(
                    vertical: 50.0,
                    horizontal: 16.0,
                  ),
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    final type = types[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 8.0,
                        ),
                        title: Text(
                          type.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue.shade700,
                                size: 24,
                              ),
                              tooltip: 'Editar',
                              onPressed: () {
                                _showEditDialog(context, type);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 26,
                              ),
                              tooltip: 'Eliminar',
                              onPressed: () {
                                showDeleteConfirmationDialog(
                                  context: context,
                                  itemName: type.name,
                                  onConfirm: () {
                                    provider.deleteServiceType(type.id);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          _showAddDialog(context);
        },
        tooltip: 'Añadir nuevo nombre',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
