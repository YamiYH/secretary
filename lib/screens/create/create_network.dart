import 'package:app/widgets/button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../models/network_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/network_provider.dart';
import '../../widgets/custom_text_form_field.dart';

class CreateNetwork extends StatefulWidget {
  final NetworkModel? networkToEdit;

  const CreateNetwork({super.key, this.networkToEdit});

  @override
  State<CreateNetwork> createState() => _CreateNetworkState();
}

class _CreateNetworkState extends State<CreateNetwork> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageRangeController;

  bool get _isEditing => widget.networkToEdit != null;

  @override
  void initState() {
    super.initState();
    // 4. Inicializa los controladores con los datos existentes si estamos editando
    _nameController = TextEditingController(
      text: widget.networkToEdit?.name ?? '',
    );
    _ageRangeController = TextEditingController(
      text: widget.networkToEdit?.ageRange ?? '',
    );
  }

  @override
  void dispose() {
    // Limpia los controladores al destruir el widget
    _nameController.dispose();
    _ageRangeController.dispose();
    super.dispose();
  }

  // 5. Lógica para guardar/actualizar
  void _submitForm() {
    // Valida el formulario
    if (_formKey.currentState!.validate()) {
      final networkProvider = Provider.of<NetworkProvider>(
        context,
        listen: false,
      );
      final logProvider = Provider.of<LogProvider>(context, listen: false);

      if (_isEditing) {
        // Lógica para ACTUALIZAR
        final updatedNetwork = NetworkModel(
          id: widget.networkToEdit!.id,
          name: _nameController.text,
          ageRange: _ageRangeController.text,
        );
        networkProvider.updateNetwork(updatedNetwork);
        logProvider.addLog(
          userName: 'Usuario Actual',
          action: LogAction.update,
          entity: LogEntity.network,
          details: 'Se actualizó la red: "${updatedNetwork.name}"',
        );
      } else {
        // Lógica para CREAR
        final newNetwork = NetworkModel(
          id: '', // El provider asignará un ID
          name: _nameController.text,
          ageRange: _ageRangeController.text,
        );
        networkProvider.addNetwork(newNetwork);
        logProvider.addLog(
          userName: 'Usuario Actual',
          action: LogAction.create,
          entity: LogEntity.network,
          details: 'Se creó la nueva red: "${newNetwork.name}"',
        );
      }
      // Regresa a la pantalla anterior
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: _isEditing ? 'Editar Red' : 'Crear Nueva Red',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 30 : 70),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 700,
            ), // Limita el ancho en pantallas grandes
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: const Text(
                      'Detalles de la Red',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextFormField(
                    labelText: 'Nombre de la Red',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, ingrese un nombre.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: 'Rango de edades',
                    controller: _ageRangeController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingrese un rango de edades. Ej: De 10 a 20 años';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button(
                        size: Size(130, 45),
                        text: _isEditing ? 'Actualizar' : 'Guardar',
                        onPressed: _submitForm,
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
