import 'package:app/widgets/button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../models/ministry_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/ministry_provider.dart';
import '../../widgets/custom_text_form_field.dart';

class CreateMinistry extends StatefulWidget {
  final MinistryModel? ministryToEdit;

  const CreateMinistry({super.key, this.ministryToEdit});

  @override
  State<CreateMinistry> createState() => _CreateMinistryState();
}

class _CreateMinistryState extends State<CreateMinistry> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _detailsController;

  // Propiedad para saber si estamos editando
  bool get _isEditing => widget.ministryToEdit != null;

  @override
  void initState() {
    super.initState();
    // Inicializa los controladores con los datos existentes si estamos editando
    _nameController = TextEditingController(
      text: widget.ministryToEdit?.name ?? '',
    );
    _detailsController = TextEditingController(
      text: widget.ministryToEdit?.details ?? '',
    );
  }

  @override
  void dispose() {
    // Limpia los controladores
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final ministryProvider = Provider.of<MinistryProvider>(
        context,
        listen: false,
      );
      final logProvider = Provider.of<LogProvider>(context, listen: false);

      if (_isEditing) {
        // Lógica para ACTUALIZAR
        final updatedMinistry = MinistryModel(
          id: widget.ministryToEdit!.id,
          name: _nameController.text,
          details: _detailsController.text,
        );
        ministryProvider.updateMinistry(updatedMinistry);
        logProvider.addLog(
          userName: 'Usuario Actual',
          action: LogAction.update,
          entity: LogEntity.ministry,
          details: 'Se actualizó el ministerio: "${updatedMinistry.name}"',
        );
      } else {
        // Lógica para CREAR
        final newMinistry = MinistryModel(
          id: '', // El provider asignará un ID
          name: _nameController.text,
          details: _detailsController.text,
        );
        ministryProvider.addMinistry(newMinistry);
        logProvider.addLog(
          userName: 'Usuario Actual',
          action: LogAction.create,
          entity: LogEntity.ministry,
          details: 'Se creó el nuevo ministerio: "${newMinistry.name}"',
        );
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: _isEditing ? 'Editar Ministerio' : 'Crear Ministerio',
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFormField(
                  controller: _nameController,
                  labelText: 'Nombre del Ministerio',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, ingrese un nombre.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _detailsController,
                  labelText: 'Detalles (opcional)',
                  maxLines: 3, // Permite más espacio para detalles
                ),
                const SizedBox(height: 30),
                Button(
                  onPressed: _submitForm,
                  // Texto del botón dinámico
                  text: _isEditing ? 'Actualizar' : 'Guardar',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
