// En tu archivo 'add_new_member_screen.dart'

import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/members.dart';
import 'package:app/widgets/button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CreateMember extends StatelessWidget {
  const CreateMember({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Crear miembro'),
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
        padding: const EdgeInsets.all(16.0),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Center(child: Image.asset('assets/02.png', height: 120)),
        const SizedBox(height: 30.0),
        CustomTextFormField(labelText: 'Nombre'),
        const SizedBox(height: 16.0),
        CustomTextFormField(labelText: 'Apellidos'),
        const SizedBox(height: 16.0),
        CustomTextFormField(labelText: 'Dirección'),
        const SizedBox(height: 16.0),
        CustomTextFormField(labelText: 'Teléfono'),
        const SizedBox(height: 16.0),
        DropDownNetwork(),
        const SizedBox(height: 30.0),
        Button(
          size: Size(150, 45),
          text: 'Guardar',
          onPressed: () {
            Navigator.push(context, createFadeRoute(const Members()));
          },
        ),
      ],
    );
  }

  Widget DropDownNetwork() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        filled: true,
        fillColor: Colors.white,
      ),
      hint: const Text('Seleccionar red'),
      items: const [
        DropdownMenuItem(value: 'Niños', child: Text('Niños')),
        DropdownMenuItem(value: 'Juveniles', child: Text('Juveniles')),
        DropdownMenuItem(value: 'Jovenes', child: Text('Jovenes')),
      ],
      onChanged: (value) {},
    );
  }
}
