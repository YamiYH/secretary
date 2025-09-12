// En tu archivo 'logs_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class Logs extends StatelessWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Registros de Actividad'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout()
              : _buildWebLayout();
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            leading: const Icon(Icons.info_outline, size: 40),
            title: Text('Usuario X ha creado un servicio'),
            subtitle: Text('Fecha: 12/09/2025, Hora: 14:00'),
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
          width: 900,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Fecha')),
              DataColumn(label: Text('Usuario')),
              DataColumn(label: Text('Acción')),
              DataColumn(label: Text('Detalles')),
            ],
            rows: List.generate(
              20,
              (index) => DataRow(
                cells: [
                  DataCell(Text('12/09/2025')),
                  DataCell(Text('Usuario $index')),
                  DataCell(Text('Acción $index')),
                  DataCell(Text('Detalles de la acción $index')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
