import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../models/role_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/role_provider.dart';
import '../../routes/page_route_builder.dart';
import '../../widgets/add_button.dart';
import '../../widgets/showDeleteConfirmationDialog.dart';
import '../create/create_role.dart';

class Roles extends StatelessWidget {
  const Roles({Key? key}) : super(key: key);

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
    return Column(
      children: [
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center,
            child: AddButton(
              size: Size(MediaQuery.of(context).size.width * 0.9, 50),
              onPressed: () {
                Navigator.push(context, createFadeRoute(CreateRole()));
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
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
                          _showDelete(context, role);
                        },
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showDelete(BuildContext context, Role role) {
    return showDeleteConfirmationDialog(
      context: context,
      itemName: role.name,
      onConfirm: () {
        Provider.of<LogProvider>(context, listen: false).addLog(
          userName: 'Usuario Actual', // Temporalmente hardcodeado
          action: LogAction.delete,
          entity: LogEntity.role, // Especifica que la entidad es un Rol
          details: 'Se eliminó el rol: "${role.name}"',
        );

        Provider.of<RoleProvider>(context, listen: false).deleteRole(role.id);
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
                                _showDelete(context, role);
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
