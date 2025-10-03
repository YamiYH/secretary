// En tu archivo 'users_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../widgets/add_button.dart';

class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Usuarios'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout()
              : _buildWebLayout(context);
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 10, // Ejemplo, deberías usar tu lista de usuarios
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            leading: const Icon(Icons.person_outline, size: 40),
            title: Text('Usuario $index'),
            subtitle: const Text('Rol: Miembro'),
            trailing: const Icon(Icons.edit),
            onTap: () {
              // Lógica para editar usuario
            },
          ),
        );
      },
    );
  }

  Widget _buildWebLayout(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AddButton(onPressed: () {}),
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
                rows: List.generate(
                  10, // Ejemplo, usar tu lista de usuarios
                  (index) => DataRow(
                    cells: [
                      DataCell(Text('Nombre $index')),
                      DataCell(Text('Apellidos')),
                      DataCell(Text('Teléfono')),
                      DataCell(
                        Text(index.isEven ? 'Administrador' : 'Miembro'),
                      ),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
