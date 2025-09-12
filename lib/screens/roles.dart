// En tu archivo 'roles_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class Roles extends StatelessWidget {
  const Roles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Roles'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout()
              : _buildWebLayout();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Añadir nuevo rol');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            leading: const Icon(Icons.shield_outlined, size: 40),
            title: Text('Rol $index'),
            subtitle: const Text('Permisos: Ver, Editar'),
            trailing: const Icon(Icons.edit),
            onTap: () {},
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
              DataColumn(label: Text('Rol')),
              DataColumn(label: Text('Descripción')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: List.generate(
              5,
              (index) => DataRow(
                cells: [
                  DataCell(Text('Rol $index')),
                  DataCell(Text('Descripción del Rol $index')),
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
