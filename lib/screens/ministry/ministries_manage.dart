import 'package:app/providers/ministry_provider.dart';
import 'package:app/screens/create/create_ministry.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../models/ministry_model.dart';
import '../../providers/log_provider.dart';
import '../../routes/page_route_builder.dart';

class MinistryManage extends StatelessWidget {
  const MinistryManage({Key? key}) : super(key: key);

  // Función para el diálogo de confirmación de borrado
  void _showDeleteConfirmationDialog(
    BuildContext context,
    MinistryModel ministry,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar el ministerio "${ministry.name}"?',
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
            onPressed: () {
              Provider.of<LogProvider>(context, listen: false).addLog(
                userName: 'Usuario Actual', // Temporalmente hardcodeado
                action: LogAction.delete,
                entity:
                    LogEntity.ministry, // Especifica que la entidad es un Rol
                details: 'Se eliminó el ministerio: "${ministry.name}"',
              );

              Provider.of<MinistryProvider>(
                context,
                listen: false,
              ).deleteMinistry(ministry.id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }

  @override
  Widget build(BuildContext context) {
    final ministryProvider = context.watch<MinistryProvider>();
    final List<MinistryModel> ministries = ministryProvider.ministries;

    //bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Gestionar ministerios'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // --- ADAPTADO: Pasar la lista de redes a los métodos de layout ---
          return ministries.isEmpty
              ? const Center(child: Text('No hay redes para mostrar.'))
              : constraints.maxWidth < 600
              ? _buildMobileLayout(context, ministries)
              : _buildWebLayout(context, ministries);
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    List<MinistryModel> ministries,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: ministries.length,
      itemBuilder: (context, index) {
        final ministry = ministries[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(ministry.name),
            subtitle: Text(ministry.details),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      createFadeRoute(CreateMinistry(ministryToEdit: ministry)),
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
                    _showDeleteConfirmationDialog(context, ministry);
                  },
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    List<MinistryModel> ministryModel,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.width * 0.15,
                columns: [
                  DataColumn(label: Text('Ministerio', style: _headerStyle())),
                  DataColumn(label: Text('Detalles', style: _headerStyle())),
                  DataColumn(label: Text('Acciones', style: _headerStyle())),
                ],
                rows: ministryModel.map((ministry) {
                  return DataRow(
                    cells: [
                      DataCell(Text(ministry.name)),
                      DataCell(Text(ministry.details)),
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
                                    CreateMinistry(ministryToEdit: ministry),
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
                                  ministry,
                                );
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
