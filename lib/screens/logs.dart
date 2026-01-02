// En tu archivo 'logs_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/log_model.dart';
import '../providers/log_provider.dart';

class Logs extends StatelessWidget {
  const Logs({Key? key}) : super(key: key);

  // Función para obtener un texto legible de la acción
  String _getActionText(LogAction action) {
    switch (action) {
      case LogAction.create:
        return 'Creación';
      case LogAction.update:
        return 'Actualización';
      case LogAction.delete:
        return 'Eliminación';
    }
  }

  @override
  Widget build(BuildContext context) {
    final logProvider = Provider.of<LogProvider>(context);
    final List<Log> logs = logProvider.logs;
    bool isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Registros de Actividad'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout(logs)
              : _buildWebLayout(context, logs);
        },
      ),
    );
  }

  Widget _buildMobileLayout(List<Log> logs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: 20,
      itemBuilder: (context, index) {
        final log = logs[index];
        // Formateamos la fecha y hora
        final formattedDate = DateFormat(
          'dd/MM/yyyy, HH:mm',
        ).format(log.timestamp);
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(log.details),
            subtitle: Text('Por: ${log.userName} - $formattedDate'),
            leading: Icon(
              log.action == LogAction.create
                  ? Icons.add_circle
                  : log.action == LogAction.update
                  ? Icons.edit
                  : Icons.delete_forever,
              color: log.action == LogAction.delete ? Colors.red : Colors.grey,
            ),
          ),
        );
      },
    );
  }

  Widget _buildWebLayout(BuildContext context, List<Log> logs) {
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
            rows: logs.map((log) {
              final formattedDate = DateFormat(
                'dd/MM/yyyy HH:mm:ss',
              ).format(log.timestamp);
              return DataRow(
                cells: [
                  DataCell(Text(formattedDate)),
                  DataCell(Text(log.userName)),
                  DataCell(Text(_getActionText(log.action))),
                  DataCell(Text(log.details)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }
}
