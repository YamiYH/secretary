// lib/screens/network_manage.dart

import 'package:app/models/network_model.dart';
import 'package:app/screens/create/create_network.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final pastorProvider = Provider.of<PastorProvider>(context, listen: false);
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
                Text(network.mission ?? 'Sin misión definida'),
                const SizedBox(height: 4),
                Text(
                  'Líderes: ${network.leaders.isEmpty ? "Sin asignar" : network.leaders.join(", ")}',
                  style: const TextStyle(fontSize: 13),
                ),
                Text('${network.membersCount} miembros'),
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
            DataColumn(label: Text('Misión', style: _headerStyle())),
            DataColumn(label: Text('Líderes', style: _headerStyle())),
            DataColumn(label: Text('Miembros', style: _headerStyle())),
            DataColumn(label: Text('Acciones', style: _headerStyle())),
          ],
          rows: networks.map((network) {
            // Usa el método del provider para obtener los nombres
            final pastorNames = network.leaders;

            final String leaderNames = network.leaders.isEmpty
                ? 'Sin asignar'
                : network.leaders.join(", ");

            return DataRow(
              cells: [
                DataCell(Text(network.name)),
                DataCell(Text(network.mission ?? 'Sin misión')),
                DataCell(
                  Tooltip(
                    message: leaderNames,
                    child: Text(leaderNames, overflow: TextOverflow.ellipsis),
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
        Provider.of<NetworkProvider>(
          context,
          listen: false,
        ).deleteNetwork(network.id);
      },
    );
  }
}
