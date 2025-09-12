// En tu archivo 'users_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Usuarios'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout()
              : _buildWebLayout();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para ir a la pantalla de agregar nuevo usuario
          print('Añadir nuevo usuario');
        },
        child: const Icon(Icons.add),
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

  Widget _buildWebLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: SizedBox(
          width: 800,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Correo')),
              DataColumn(label: Text('Rol')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: List.generate(
              10, // Ejemplo, usar tu lista de usuarios
              (index) => DataRow(
                cells: [
                  DataCell(Text('Usuario $index')),
                  DataCell(Text('usuario$index@ejemplo.com')),
                  DataCell(Text(index.isEven ? 'Administrador' : 'Miembro')),
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
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
    );
  }
}
