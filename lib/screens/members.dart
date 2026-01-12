import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/create/create_member.dart';
import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/showDeleteConfirmationDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../models/log_model.dart';
import '../models/member_model.dart';
import '../providers/log_provider.dart';
import '../providers/member_provider.dart';
import '../widgets/menu.dart';
import '../widgets/search_text_field.dart';

class Members extends StatelessWidget {
  const Members({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    // 1. Obtener la instancia del provider.
    //    Usamos 'watch' (el método por defecto) para que la UI se reconstruya cuando cambien los datos.
    final memberProvider = Provider.of<MemberProvider>(context);
    final List<Member> filteredMembers = memberProvider.filteredMembers;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Miembros', isDrawerEnabled: isMobile),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: isMobile
          ? _buildMembersContent(
              context,
              isMobile,
              memberProvider,
              filteredMembers,
            )
          : Row(
              children: [
                Menu(),
                Expanded(
                  child: _buildMembersContent(
                    context,
                    isMobile,
                    memberProvider,
                    filteredMembers,
                  ),
                ),
              ],
            ),
    );
  }

  // Este widget ahora recibe el provider y la lista de miembros como parámetros
  Widget _buildMembersContent(
    BuildContext context,
    bool isMobile,
    MemberProvider provider,
    List<Member> members,
  ) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Barra de búsqueda
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 18.0 : 24.0),
          child: isMobile
              ? _buildMobileLayout(context, provider)
              : _buildWebLayout(provider, context),
        ),
        SizedBox(height: isMobile ? 15 : 30),
        // Lista de miembros
        Expanded(
          child: _buildMemberList(context, isMobile, members),
        ), // Pasa la lista filtrada
      ],
    );
  }

  Row _buildWebLayout(MemberProvider provider, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          // 2. El SearchTextField ahora llama al método del provider
          child: SearchTextField(
            onChanged: (query) {
              // Llama al método 'search' del provider en lugar de a un listener local.
              provider.search(query);
            },
            controller: null,
          ),
        ),
        const SizedBox(width: 20),
        AddButton(
          onPressed: () {
            Navigator.push(context, createFadeRoute(const CreateMember()));
          },
        ),
      ],
    );
  }

  Column _buildMobileLayout(BuildContext context, MemberProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 2. El SearchTextField ahora llama al método del provider
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: SearchTextField(
            onChanged: (query) {
              // Llama al método 'search' del provider en lugar de a un listener local.
              provider.search(query);
            },
            controller: null,
          ),
        ),

        const SizedBox(height: 15),
        AddButton(
          size: Size(MediaQuery.of(context).size.width * 0.9, 50),

          onPressed: () {
            Navigator.push(context, createFadeRoute(const CreateMember()));
          },
        ),
      ],
    );
  }

  Widget _buildMemberList(
    BuildContext context,
    bool isMobile,
    List<Member> members,
  ) {
    if (members.isEmpty) {
      return const Center(child: Text('No se encontraron miembros.'));
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2.5,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(isMobile ? 10.0 : 25),
          itemCount: members.length,
          itemBuilder: (context, index) {
            final member = members[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.1),
                child: Text(
                  member.name.isNotEmpty
                      ? member.name.substring(0, 1).toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: Colors.redAccent[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                '${member.name} ${member.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              // 3. Muestra los grupos de forma más elegante
              subtitle: Text(
                member.group,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize:
                    MainAxisSize.min, // Para que ocupe el mínimo espacio
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue[600]),
                    onPressed: () {
                      Navigator.push(
                        context,
                        createFadeRoute(CreateMember(memberToEdit: member)),
                      );
                    },
                  ),

                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[600]),
                    onPressed: () {
                      showDeleteConfirmationDialog(
                        context: context,
                        itemName: member.name,
                        onConfirm: () {
                          final memberProvider = Provider.of<MemberProvider>(
                            context,
                            listen: false,
                          );
                          final logProvider = Provider.of<LogProvider>(
                            context,
                            listen: false,
                          );

                          logProvider.addLog(
                            userName: 'Admin',
                            action: LogAction.delete,
                            entity: LogEntity.user,
                            details: 'Se eliminó al miembro: "${member.name}"',
                          );
                          memberProvider.deleteMember(member.id);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
