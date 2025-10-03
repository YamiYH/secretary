// En tu archivo 'roles_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../widgets/add_button.dart';

class Roles extends StatelessWidget {
  const Roles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Roles'),
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
              width: MediaQuery.of(context).size.width * 0.7,
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.width * 0.15,
                columns: [
                  DataColumn(label: Text('Rol', style: _headerStyle())),
                  DataColumn(label: Text('Descripción', style: _headerStyle())),
                  DataColumn(label: Text('Acciones', style: _headerStyle())),
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
