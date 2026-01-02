// lib/screens/create/create_role.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../models/role_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/role_provider.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_form_field.dart';

class CreateRole extends StatefulWidget {
  final Role? roleToEdit;
  const CreateRole({Key? key, this.roleToEdit}) : super(key: key);

  @override
  _CreateRoleState createState() => _CreateRoleState();
}

class _CreateRoleState extends State<CreateRole> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get _isEditing => widget.roleToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _nameController.text = widget.roleToEdit!.name;
      _descriptionController.text = widget.roleToEdit!.description;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveRole() {
    if (_formKey.currentState!.validate()) {
      final logProvider = Provider.of<LogProvider>(context, listen: false);

      if (_isEditing) {
        final updatedRole = Role(
          id: widget.roleToEdit!.id,
          name: _nameController.text,
          description: _descriptionController.text,
        );
        Provider.of<RoleProvider>(
          context,
          listen: false,
        ).updateRole(updatedRole);

        // --- AÑADIR LOG DE ACTUALIZACIÓN ---
        logProvider.addLog(
          userName: 'Usuario Actual', // Temporalmente hardcodeado
          action: LogAction.update,
          entity: LogEntity.role, // Especifica que la entidad es un Rol
          details: 'Se actualizó el rol: "${updatedRole.name}"',
        );
      } else {
        final newRole = Role(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          description: _descriptionController.text,
        );
        Provider.of<RoleProvider>(context, listen: false).addRole(newRole);

        // --- AÑADIR LOG DE CREACIÓN ---
        logProvider.addLog(
          userName: 'Usuario Actual', // Temporalmente hardcodeado
          action: LogAction.create,
          entity: LogEntity.role, // Especifica que la entidad es un Rol
          details: 'Se creó el nuevo rol: "${newRole.name}"',
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _isEditing ? 'Editar Rol' : 'Crear Rol'),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(50.0),
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.admin_panel_settings,
                    size: 120,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 30),
                  CustomTextFormField(
                    controller: _nameController,
                    labelText: 'Nombre del Rol',
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'El nombre es obligatorio'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _descriptionController,
                    labelText: 'Descripción',
                    maxLines: 3,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'La descripción es obligatoria'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Button(
                      size: const Size(150, 45),
                      text: 'Guardar',
                      onPressed: _saveRole,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
