// lib/screens/create/create_user.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/member_model.dart';
import '../../models/user_model.dart';
import '../../providers/member_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/button.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_text_form_field.dart';

class CreateUser extends StatefulWidget {
  final User? userToEdit;
  const CreateUser({Key? key, this.userToEdit}) : super(key: key);

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _memberAutocompleteController;
  String _selectedRole = 'Miembro';
  String? _selectedMemberId;

  bool get _isEditing => widget.userToEdit != null;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController(
      text: widget.userToEdit?.userName ?? '',
    );
    _passwordController = TextEditingController();
    _selectedRole = widget.userToEdit?.role ?? 'Miembro';
    _memberAutocompleteController = TextEditingController();
    _selectedMemberId = widget.userToEdit?.memberId;

    if (_isEditing && _selectedMemberId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final memberProvider = Provider.of<MemberProvider>(
          context,
          listen: false,
        );
        try {
          final member = memberProvider.allMembers.firstWhere(
            (m) => m.id == _selectedMemberId,
          );
          _memberAutocompleteController.text = member.name;
        } catch (e) {
          _selectedMemberId = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _memberAutocompleteController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (!_formKey.currentState!.validate()) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (_isEditing) {
      final updatedUser = widget.userToEdit!.copyWith(
        userName: _userNameController.text.trim(),
        role: _selectedRole,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : widget.userToEdit!.password,
        memberId: _selectedMemberId,
      );
      userProvider.updateUser(updatedUser);
    } else {
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userName: _userNameController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
        memberId: _selectedMemberId,
      );
      userProvider.addUser(newUser);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);
    final List<Member> allMembers = memberProvider.allMembers;

    return Scaffold(
      appBar: CustomAppBar(
        title: _isEditing ? 'Editar Usuario' : 'Crear Usuario',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 30 : 70),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.account_circle, size: 120, color: Colors.grey),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    controller: _userNameController,
                    labelText: 'Nombre de usuario',
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'El nombre de usuario no puede estar vacío.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: 'Contraseña',
                    obscureText: true,
                    validator: (v) => (!_isEditing && (v == null || v.isEmpty))
                        ? 'La contraseña no puede estar vacía.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: isMobile ? 55 : 65,
                    child: DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Rol',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Administrador', 'Miembro', 'Invitado']
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => _selectedRole = v ?? 'Miembro'),
                    ),
                  ),
                  //const SizedBox(height: 16),
                  SizedBox(
                    height: isMobile ? 55 : 65,
                    child: Autocomplete<Member>(
                      displayStringForOption: (Member option) => option.name,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<Member>.empty();
                        }
                        return allMembers.where(
                          (m) => m.name.toLowerCase().contains(
                            textEditingValue.text.toLowerCase(),
                          ),
                        );
                      },
                      onSelected: (Member selection) =>
                          setState(() => _selectedMemberId = selection.id),
                      fieldViewBuilder:
                          (
                            context,
                            fieldController,
                            fieldFocusNode,
                            onFieldSubmitted,
                          ) {
                            _memberAutocompleteController = fieldController;
                            return TextFormField(
                              controller: fieldController,
                              focusNode: fieldFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Asociar a Miembro (Opcional)',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    fieldController.clear();
                                    setState(() => _selectedMemberId = null);
                                    fieldFocusNode.unfocus();
                                  },
                                ),
                              ),
                            );
                          },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button(
                        size: Size(
                          isMobile
                              ? MediaQuery.of(context).size.width * 0.9
                              : 170,
                          isMobile ? 50 : 45,
                        ),
                        text: _isEditing ? 'Guardar Cambios' : 'Crear Usuario',
                        onPressed: _saveUser,
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
