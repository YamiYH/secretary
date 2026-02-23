import 'package:app/widgets/button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/ministry_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/ministry_provider.dart';
import '../../providers/pastor_provider.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/multi_select_dialog.dart';

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

  Set<String> _selectedPastorIds = {};
  bool get _isEditing => widget.ministryToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.ministryToEdit?.name ?? '',
    );
    _detailsController = TextEditingController(
      text: widget.ministryToEdit?.details ?? '',
    );

    if (_isEditing) {
      _selectedPastorIds = widget.ministryToEdit!.pastorIds.toSet();
    }
    ;
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
          pastorIds: _selectedPastorIds.toList(),
        );
        ministryProvider.updateMinistry(updatedMinistry);
      } else {
        // Lógica para CREAR
        final newMinistry = MinistryModel(
          id: '', // El provider asignará un ID
          name: _nameController.text,
          details: _detailsController.text,
          pastorIds: _selectedPastorIds.toList(),
        );
        ministryProvider.addMinistry(newMinistry);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    final pastorProvider = Provider.of<PastorProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: _isEditing ? 'Editar Ministerio' : 'Crear Ministerio',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 30 : 70),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Center(
                    child: const Text(
                      'Detalles del Ministerio',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
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
                    labelText: 'Descripción',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese descripción del ministerio';
                      }
                      return null;
                    },
                    //maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () async {
                      final Set<String>? result = await showDialog<Set<String>>(
                        context: context,
                        builder: (ctx) => MultiSelectDialog<String>(
                          title: 'Seleccionar Pastores',
                          items: pastorProvider.pastors
                              .map((p) => p.id)
                              .toList(),
                          initialSelectedItems: _selectedPastorIds,
                          displayItem: (pastorId) =>
                              pastorProvider.findById(pastorId).name,
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _selectedPastorIds = result;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Pastores a Cargo',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      child: _selectedPastorIds.isEmpty
                          ? Text(
                              'Ninguno seleccionado',
                              style: TextStyle(color: Colors.grey.shade600),
                            )
                          : Text(
                              pastorProvider.getPastorNamesByIds(
                                _selectedPastorIds.toList(),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button(
                        size: Size(130, 45),
                        onPressed: _submitForm,
                        // Texto del botón dinámico
                        text: _isEditing ? 'Actualizar' : 'Guardar',
                      ),
                    ],
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
