import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/log_model.dart';
import '../models/role_model.dart';
import '../providers/log_provider.dart';
import '../providers/role_provider.dart';
import '../routes/page_route_builder.dart';
import '../widgets/add_button.dart';
import 'create/create_role.dart';

class Roles extends StatelessWidget {
  const Roles({Key? key}) : super(key: key);

  // Función para el diálogo de confirmación de borrado
  void _showDeleteConfirmationDialog(BuildContext context, Role role) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar el rol "${role.name}"?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
            onPressed: () {
              Provider.of<LogProvider>(context, listen: false).addLog(
                userName: 'Usuario Actual', // Temporalmente hardcodeado
                action: LogAction.delete,
                entity: LogEntity.role, // Especifica que la entidad es un Rol
                details: 'Se eliminó el rol: "${role.name}"',
              );

              Provider.of<RoleProvider>(
                context,
                listen: false,
              ).deleteRole(role.id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }

  @override
  Widget build(BuildContext context) {
    final roleProvider = Provider.of<RoleProvider>(context);
    final List<Role> roles = roleProvider.roles;

    //bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Roles'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout(context, roles)
              : _buildWebLayout(context, roles);
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<Role> roles) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(role.name),
            subtitle: Text(role.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      createFadeRoute(CreateRole(roleToEdit: role)),
                    );
                  },
                ),

                // 2. Botón de Eliminar
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ), // Ícono de eliminar
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, role);
                  },
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildWebLayout(BuildContext context, List<Role> roles) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AddButton(
                onPressed: () {
                  Navigator.push(context, createFadeRoute(const CreateRole()));
                },
              ),
              SizedBox(width: 35),
            ],
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.width * 0.15,
                columns: [
                  DataColumn(label: Text('Rol', style: _headerStyle())),
                  DataColumn(label: Text('Descripción', style: _headerStyle())),
                  DataColumn(label: Text('Acciones', style: _headerStyle())),
                ],
                rows: roles.map((role) {
                  return DataRow(
                    cells: [
                      DataCell(Text(role.name)),
                      DataCell(Text(role.description)),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  createFadeRoute(CreateRole(roleToEdit: role)),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, role);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
