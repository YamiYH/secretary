// En tu archivo 'add_new_member_screen.dart'

import 'package:app/widgets/button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/log_model.dart';
import '../../models/member_model.dart';
import '../../providers/log_provider.dart';
import '../../providers/member_provider.dart';

class CreateMember extends StatefulWidget {
  final Member? memberToEdit;
  const CreateMember({Key? key, this.memberToEdit}) : super(key: key);

  @override
  State<CreateMember> createState() => _CreateMemberState();
}

class _CreateMemberState extends State<CreateMember> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _selectedBirthDate;

  String? _selectedGroup;

  bool get _isEditing => widget.memberToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final member = widget.memberToEdit!;

      _nameController.text = member.name;
      _lastNameController.text = member.lastName;
      _phoneController.text = member.phone;
      _addressController.text = member.address;
      _selectedGroup = member.group;
      _selectedBirthDate = member.birthDate;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveMember() {
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una fecha de nacimiento.'),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final memberProvider = Provider.of<MemberProvider>(
        context,
        listen: false,
      );
      final logProvider = Provider.of<LogProvider>(context, listen: false);

      final String name = _nameController.text.trim();
      final String lastName = _lastNameController.text.trim();
      final String logDisplayName = '$name $lastName'.trim();
      final String group = _selectedGroup!;

      if (_isEditing) {
        final updatedMember = Member(
          id: widget.memberToEdit!.id,
          name: name,
          lastName: lastName,
          phone: _phoneController.text,
          address: _addressController.text,
          birthDate: _selectedBirthDate!,
          group: group,
          registrationDate: widget.memberToEdit!.registrationDate,
        );
        memberProvider.updateMember(updatedMember);
        logProvider.addLog(
          userName: 'Admin',
          action: LogAction.update,
          entity: LogEntity.user,
          details: 'Se actualizó al miembro: $name $lastName',
        );
      } else {
        final newMember = Member(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          lastName: lastName,
          phone: _phoneController.text,
          address: _addressController.text,
          birthDate: _selectedBirthDate!,
          group: group,
          registrationDate: DateTime.now(),
        );
        memberProvider.addMember(newMember);
        logProvider.addLog(
          userName: 'Admin',
          action: LogAction.create,
          entity: LogEntity.user,
          details: 'Se creó al miembro: $name $lastName',
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Crear miembro'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return isMobile ? _buildMobileLayout() : _buildWebLayout();
        },
      ),
    );
  }

  // --- Layout para móvil ---
  Widget _buildMobileLayout() {
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
  Widget _buildWebLayout() {
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
          Center(child: Image.asset('assets/02.png', height: 120)),
          const SizedBox(height: 30.0),
          CustomTextFormField(
            labelText: 'Nombre',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El nombre es obligatorio';
              }
              if (value.length < 3) {
                return 'El nombre debe tener al menos 3 caracteres';
              }
              return null; // Válido
            },
            controller: _nameController,
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            labelText: 'Apellidos',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Los apellidos son obligatorios';
              }
              return null; // Válido
            },
            controller: _lastNameController,
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            labelText: 'Dirección',
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'La dirección es obligatoria'
                : null,
            controller: _addressController,
          ),
          const SizedBox(height: 16.0),
          CustomTextFormField(
            labelText: 'Teléfono',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'El teléfono es obligatorio';
              }
              if (value.length < 8) {
                return 'El teléfono debe tener al menos 8 números';
              }
              return null; // Válido
            },

            controller: _phoneController,
          ),
          const SizedBox(height: 16.0),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.calendar_today),
            title: const Text('Fecha de Nacimiento'),
            subtitle: Text(
              _selectedBirthDate == null
                  ? 'No seleccionada'
                  : DateFormat(
                      'dd/MM/yyyy',
                      'es_ES',
                    ).format(_selectedBirthDate!),
            ),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedBirthDate ?? DateTime.now(),
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedBirthDate = picked;
                });
              }
            },
          ),
          DropDownNetwork(),
          const SizedBox(height: 30.0),
          Button(size: Size(150, 45), text: 'Guardar', onPressed: _saveMember),
        ],
      ),
    );
  }

  Widget DropDownNetwork() {
    return DropdownButtonFormField<String>(
      value: _selectedGroup,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: const Text('Seleccionar red'),
      items: const [
        DropdownMenuItem(value: 'Niños', child: Text('Niños')),
        DropdownMenuItem(value: 'Juveniles', child: Text('Juveniles')),
        DropdownMenuItem(value: 'Jóvenes', child: Text('Jóvenes')),
        DropdownMenuItem(value: 'Mujeres', child: Text('Mujeres')),
        DropdownMenuItem(value: 'Hombres', child: Text('Hombres')),
        DropdownMenuItem(value: '3ra Edad', child: Text('3ra Edad')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedGroup = value;
        });
      },
      // --- CAMBIO: Hacemos que el campo sea obligatorio ---
      validator: (value) => value == null ? 'Debe seleccionar un grupo' : null,
    );
  }
}
