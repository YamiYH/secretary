import 'package:app/providers/ministry_provider.dart';
import 'package:app/screens/create/create_ministry.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/ministry_model.dart';
import '../../providers/pastor_provider.dart';
import '../../routes/page_route_builder.dart';
import '../../widgets/showDeleteConfirmationDialog.dart';

class MinistryManage extends StatelessWidget {
  const MinistryManage({Key? key}) : super(key: key);

  TextStyle _headerStyle() {
    return TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
  }

  @override
  Widget build(BuildContext context) {
    final ministryProvider = context.watch<MinistryProvider>();
    final List<MinistryModel> ministries = ministryProvider.ministries;
    final pastorProvider = context.watch<PastorProvider>();

    //bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Gestionar ministerios'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ministries.isEmpty
              ? const Center(child: Text('No hay redes para mostrar.'))
              : constraints.maxWidth < 700
              ? _buildMobileLayout(context, ministries, pastorProvider)
              : _buildWebLayout(context, ministries, pastorProvider);
        },
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    List<MinistryModel> ministries,
    PastorProvider pastorProvider,
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
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ministry.details,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // 3. Mostramos los pastores asignados
                Text(
                  'Pastores: ${pastorProvider.getPastorNamesByIds(ministry.pastorIds)}',
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
                    _showDelete(context, ministry);
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

  Future<void> _showDelete(BuildContext context, MinistryModel ministry) {
    return showDeleteConfirmationDialog(
      context: context,
      itemName: ministry.name,
      onConfirm: () {
        Provider.of<MinistryProvider>(
          context,
          listen: false,
        ).deleteMinistry(ministry.id);
        //Navigator.of(context).pop();
      },
    );
  }

  Widget _buildWebLayout(
    BuildContext context,
    List<MinistryModel> ministries,
    PastorProvider pastorProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DataTable(
                columnSpacing: MediaQuery.of(context).size.width * 0.15,
                columns: [
                  DataColumn(label: Text('Ministerio', style: _headerStyle())),
                  DataColumn(label: Text('Detalles', style: _headerStyle())),
                  DataColumn(label: Text('Pastores', style: _headerStyle())),
                  DataColumn(label: Text('Acciones', style: _headerStyle())),
                ],
                rows: ministries.map((ministry) {
                  final pastorNames = pastorProvider.getPastorNamesByIds(
                    ministry.pastorIds,
                  );
                  return DataRow(
                    cells: [
                      DataCell(Text(ministry.name)),
                      DataCell(Text(ministry.details)),
                      DataCell(
                        Tooltip(
                          message: pastorNames,
                          child: Text(
                            pastorNames,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                                _showDelete(context, ministry);
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
