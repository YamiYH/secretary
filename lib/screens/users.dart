// En tu archivo 'users_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/log_model.dart';
import '../models/user_model.dart';
import '../providers/log_provider.dart';
import '../providers/user_provider.dart';
import '../routes/page_route_builder.dart';
import '../widgets/add_button.dart';
import 'create/create_user.dart';

class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //bool isMobile = MediaQuery.of(context).size.width < 700;
    final userProvider = Provider.of<UserProvider>(context);
    final List<User> users = userProvider.users;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Usuarios'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout(context, users)
              : _buildWebLayout(context, users);
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<User> users) {
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
                Navigator.push(context, createFadeRoute(CreateUser()));
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),

            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index]; // Obtener el usuario actual
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  title: Text('${user.name} ${user.lastName}\n${user.phone}'),
                  subtitle: Text('Rol: ${user.role}'),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            createFadeRoute(CreateUser(userToEdit: user)),
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
                          _showDeleteConfirmationDialog(context, user);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Lógica para editar usuario
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWebLayout(BuildContext context, List<User> users) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AddButton(
                onPressed: () {
                  Navigator.push(context, createFadeRoute(CreateUser()));
                },
              ),
              SizedBox(width: 35),
            ],
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.width * 0.15,
                columns: [
                  DataColumn(label: Text('Nombre', style: _headerStyle())),
                  DataColumn(label: Text('Apellidos', style: _headerStyle())),
                  DataColumn(label: Text('Teléfono', style: _headerStyle())),
                  DataColumn(label: Text('Rol', style: _headerStyle())),
                  DataColumn(label: Text('Acciones', style: _headerStyle())),
                ],
                rows: users
                    .map(
                      (user) => DataRow(
                        cells: [
                          DataCell(Text(user.name)),
                          DataCell(Text(user.lastName)),
                          DataCell(Text(user.phone)),
                          DataCell(Text(user.role)),
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
                                      createFadeRoute(
                                        CreateUser(userToEdit: user),
                                      ),
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
                                    _showDeleteConfirmationDialog(
                                      context,
                                      user,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text(
            '¿Estás seguro de que deseas eliminar a ${user.name} ${user.lastName}?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
              onPressed: () {
                Provider.of<LogProvider>(context, listen: false).addLog(
                  userName: 'Usuario Actual',
                  action: LogAction.delete,
                  entity: LogEntity.user,
                  details:
                      'Se eliminó al usuario: ${user.name} ${user.lastName}',
                );
                // Llama al provider para eliminar el usuario
                Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).deleteUser(user.id);
                Navigator.of(ctx).pop(); // Cierra el diálogo
              },
            ),
          ],
        );
      },
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }
}
