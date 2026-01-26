// lib/screens/network_manage.dart

import 'package:app/models/network_model.dart';
import 'package:app/screens/create/create_network.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/network_provider.dart';
import '../../providers/pastor_provider.dart'; // <-- Importa el PastorProvider
import '../../routes/page_route_builder.dart';
import '../../widgets/showDeleteConfirmationDialog.dart';

class NetworkManage extends StatelessWidget {
  const NetworkManage({Key? key}) : super(key: key);

  TextStyle _headerStyle() {
    return const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }

  @override
  Widget build(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context);
    final pastorProvider = Provider.of<PastorProvider>(
      context,
      listen: false,
    ); // <-- Obtén el PastorProvider
    final List<NetworkModel> networks = networkProvider.networks;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Gestionar redes'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return networks.isEmpty
              ? const Center(child: Text('No hay redes para mostrar.'))
              : constraints.maxWidth < 700
              ? _buildMobileLayout(
                  context,
                  networks,
                  pastorProvider,
                ) // Pasa el provider
              : _buildWebLayout(
                  context,
                  networks,
                  pastorProvider,
                ); // Pasa el provider
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    List<NetworkModel> networks,
    PastorProvider pastorProvider,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: networks.length,
      itemBuilder: (context, index) {
        final network = networks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: ListTile(
            title: Text(
              network.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  network.ageRange.isNotEmpty
                      ? 'Edades: ${network.ageRange}'
                      : 'Sin rango de edad',
                ),
                const SizedBox(height: 4),
                // Usa el método del provider para obtener los nombres
                Text(
                  'Pastores: ${pastorProvider.getPastorNamesByIds(network.pastorIds)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => Navigator.push(
                    context,
                    createFadeRoute(CreateNetwork(networkToEdit: network)),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDelete(context, network),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    List<NetworkModel> networks,
    PastorProvider pastorProvider,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(30.0),
      child: Center(
        child: DataTable(
          columnSpacing: 130.0,
          columns: [
            DataColumn(label: Text('Red', style: _headerStyle())),
            DataColumn(label: Text('Rango de edades', style: _headerStyle())),
            DataColumn(label: Text('Pastores', style: _headerStyle())),
            DataColumn(label: Text('Acciones', style: _headerStyle())),
          ],
          rows: networks.map((network) {
            // Usa el método del provider para obtener los nombres
            final pastorNames = pastorProvider.getPastorNamesByIds(
              network.pastorIds,
            );
            return DataRow(
              cells: [
                DataCell(Text(network.name)),
                DataCell(Text(network.ageRange)),
                DataCell(
                  Tooltip(
                    message: pastorNames,
                    child: Text(pastorNames, overflow: TextOverflow.ellipsis),
                  ),
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
                        onPressed: () => Navigator.push(
                          context,
                          createFadeRoute(
                            CreateNetwork(networkToEdit: network),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDelete(context, network),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  // El método _showDelete no necesita cambios
  void _showDelete(BuildContext context, NetworkModel network) {
    showDeleteConfirmationDialog(
      context: context,
      itemName: network.name,
      onConfirm: () {
        Provider.of<LogProvider>(context, listen: false).addLog(
          userName: 'Admin',
          action: LogAction.delete,
          entity: LogEntity.network,
          details: 'Se eliminó la red: "${network.name}"',
        );
        Provider.of<NetworkProvider>(
          context,
          listen: false,
        ).deleteNetwork(network.id);
      },
    );
  }
}
