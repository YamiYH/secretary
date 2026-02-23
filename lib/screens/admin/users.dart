// En tu archivo 'users_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/showDeleteConfirmationDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/role_provider.dart';
import '../../providers/user_provider.dart';
import '../../routes/page_route_builder.dart';
import '../../widgets/add_button.dart';
import '../../widgets/button.dart';
import '../create/create_user.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    super.initState();
    // Usamos addPostFrameCallback para asegurar que el 'context' esté disponible.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Llamamos al provider para que inicie la carga de datos.
      Provider.of<UserProvider>(context, listen: false).fetchUsers();
      Provider.of<RoleProvider>(context, listen: false).fetchRoles();
    });
  }

  @override
  Widget build(BuildContext context) {
    //bool isMobile = MediaQuery.of(context).size.width < 700;
    final userProvider = Provider.of<UserProvider>(context);
    final List<User> users = userProvider.users;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Usuarios'),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // --- Caso 1: Cargando ---
          if (userProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- Caso 2: Error ---
          if (userProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${userProvider.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 45),
                  Button(
                    text: 'Reintentar',
                    onPressed: () => userProvider.fetchUsers(),
                    size: const Size(160, 45),
                  ),
                ],
              ),
            );
          }
          final users = userProvider.users;
          return LayoutBuilder(
            builder: (context, constraints) {
              return constraints.maxWidth < 600
                  ? _buildMobileLayout(context, users)
                  : _buildWebLayout(context, users);
            },
          );
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
              final user = users[index];
              return Card(
                margin: EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  title: Text(user.username),
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
                          //_showDelete(context, user);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showDelete(BuildContext context, User user) {
    return showDeleteConfirmationDialog(
      context: context,
      itemName: user.username,
      onConfirm: () {
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        userProvider.deleteUser(user.username);
      },
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
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1000),
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.width * 0.15,
                columns: [
                  DataColumn(
                    label: Text('Nombre de usuario', style: _headerStyle()),
                  ),
                  DataColumn(label: Text('Rol', style: _headerStyle())),
                  DataColumn(label: Text('Acciones', style: _headerStyle())),
                ],
                rows: users
                    .map(
                      (user) => DataRow(
                        cells: [
                          DataCell(Text(user.username)),
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
                                    _showDelete(context, user);
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

  TextStyle _headerStyle() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }
}
