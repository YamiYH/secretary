import 'package:app/models/network_model.dart';
import 'package:app/screens/create/create_network.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/network_provider.dart';
import '../../routes/page_route_builder.dart';

class NetworkManage extends StatelessWidget {
  const NetworkManage({Key? key}) : super(key: key);

  // Función para el diálogo de confirmación de borrado
  void _showDeleteConfirmationDialog(
    BuildContext context,
    NetworkModel network,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar la red "${network.name}"?',
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
                    LogEntity.network, // Especifica que la entidad es un Rol
                details: 'Se eliminó la red: "${network.name}"',
              );

              Provider.of<NetworkProvider>(
                context,
                listen: false,
              ).deleteNetwork(network.id);
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
    final networkProvider = Provider.of<NetworkProvider>(context);
    final List<NetworkModel> networks = networkProvider.networks;

    //bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Gestionar redes'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // --- ADAPTADO: Pasar la lista de redes a los métodos de layout ---
          return networks.isEmpty
              ? const Center(child: Text('No hay redes para mostrar.'))
              : constraints.maxWidth < 600
              ? _buildMobileLayout(context, networks)
              : _buildWebLayout(context, networks);
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, List<NetworkModel> networks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: networks.length,
      itemBuilder: (context, index) {
        final network = networks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(network.name),
            subtitle: Text(
              network.ageRange.isNotEmpty
                  ? network.ageRange
                  : 'Sin rango de edad',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      createFadeRoute(CreateNetwork(networkToEdit: network)),
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
                    _showDeleteConfirmationDialog(context, network);
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
    List<NetworkModel> networkModel,
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
                  DataColumn(label: Text('Red', style: _headerStyle())),
                  DataColumn(
                    label: Text('Rango de edades', style: _headerStyle()),
                  ),
                  DataColumn(label: Text('Acciones', style: _headerStyle())),
                ],
                rows: networkModel.map((network) {
                  return DataRow(
                    cells: [
                      DataCell(Text(network.name)),
                      DataCell(Text(network.ageRange)),
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
                                    CreateNetwork(networkToEdit: network),
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
                                _showDeleteConfirmationDialog(context, network);
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
