// En tu archivo 'add_new_member_screen.dart'

import 'package:app/widgets/button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../models/user_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/user_provider.dart';

class CreateUser extends StatefulWidget {
  final User? userToEdit;
  const CreateUser({Key? key, this.userToEdit}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedRole;
  bool get _isEditing => widget.userToEdit != null;

  final List<String> _roles = [
    'Administrador',
    'Editor',
    'Miembro',
    'Visitante',
    'Líder de Jóvenes',
  ];

  @override
  void initState() {
    super.initState();
    // 3. Si estamos editando, rellenamos los campos con los datos del usuario
    if (_isEditing) {
      _nameController.text = widget.userToEdit!.name;
      _lastNameController.text = widget.userToEdit!.lastName;
      _phoneController.text = widget.userToEdit!.phone;
      _selectedRole = widget.userToEdit!.role;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final logProvider = Provider.of<LogProvider>(context, listen: false);
      if (_isEditing) {
        final updatedUser = User(
          id: widget.userToEdit!.id,
          name: _nameController.text,
          lastName: _lastNameController.text,
          phone: _phoneController.text,
          role: _selectedRole!,
        );
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).updateUser(updatedUser);
        logProvider.addLog(
          userName:
              'Usuario Actual', // Reemplazar con el nombre del usuario logueado
          action: LogAction.update,
          entity: LogEntity.user,
          details:
              'Se actualizó al usuario: ${updatedUser.name} ${updatedUser.lastName}',
        );
      } else {
        final newUser = User(
          id: DateTime.now().millisecondsSinceEpoch
              .toString(), // ID único simple
          name: _nameController.text,
          lastName: _lastNameController.text,
          phone: _phoneController.text,
          role: _selectedRole!,
        );

        Provider.of<UserProvider>(context, listen: false).addUser(newUser);
        logProvider.addLog(
          userName: 'Usuario Actual',
          action: LogAction.create,
          entity: LogEntity.user,
          details:
              'Se creó al nuevo usuario: ${newUser.name} ${newUser.lastName}',
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, corrige los errores del formulario'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: _isEditing ? 'Editar Usuario' : 'Crear Usuario',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return isMobile
              ? _buildMobileLayout(context)
              : _buildWebLayout(context);
        },
      ),
    );
  }

  // --- Layout para móvil ---
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24.0),
            _buildFormFields(context), // Pasamos el context
          ],
        ),
      ),
    );
  }

  // --- Layout para web ---
  Widget _buildWebLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(50.0),
          child: _buildFormFields(context),
        ),
      ),
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Center(child: Image.asset('assets/perfil.png', height: 120)),
          const SizedBox(height: 30.0),
          CustomTextFormField(
            labelText: 'Nombre',
            controller: _nameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El nombre es obligatorio';
              }
              if (value.length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null; // Válido
            },
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            labelText: 'Apellidos',
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Los apellidos son obligatorios';
              }
              return null; // Válido
            },
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            labelText: 'Teléfono',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El teléfono es obligatorio';
              }
              // Expresión regular simple para verificar si son solo números (y opcionalmente guiones o espacios)
              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                return 'Introduce un número de teléfono válido';
              }
              return null; // Válido
            },
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            hint: const Text(
              'Selecciona un rol',
            ), // Texto que aparece cuando no hay nada seleccionado
            decoration: InputDecoration(
              labelText: 'Rol',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
            ),
            items: _roles.map((String role) {
              return DropdownMenuItem<String>(value: role, child: Text(role));
            }).toList(),
            validator: (value) =>
                value == null ? 'Por favor, selecciona un rol' : null,
            onChanged: (String? newValue) {
              setState(() {
                _selectedRole = newValue;
              });
            },
          ),

          const SizedBox(height: 16.0),
          Button(
            size: const Size(150, 45),
            text: 'Guardar',
            onPressed: () {
              _saveUser();
            },
          ),
        ],
      ),
    );
  }
}
