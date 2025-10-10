// En tu archivo 'logs_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class Logs extends StatelessWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Registros de Actividad'),
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
      itemCount: 20,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text('Usuario X ha creado un servicio'),
            subtitle: Text('Fecha: 12/09/2025, Hora: 14:00'),
          ),
        );
      },
    );
  }

  Widget _buildWebLayout(context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          child: DataTable(
            columnSpacing: MediaQuery.of(context).size.width * 0.1,
            columns: [
              DataColumn(label: Text('Fecha', style: _headerStyle())),
              DataColumn(label: Text('Usuario', style: _headerStyle())),
              DataColumn(label: Text('Acción', style: _headerStyle())),
              DataColumn(label: Text('Detalles', style: _headerStyle())),
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

  TextStyle _headerStyle() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }
}
