import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  SearchTextField({super.key, this.onChanged, this.controller, this.validator});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late final TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    // 3. Decidimos qué controller usar.
    // Si el widget padre nos da uno, lo usamos. Si no, usamos el nuestro.
    _internalController = widget.controller ?? TextEditingController();

    // 4. Añadimos el listener para notificar los cambios a través de onChanged.
    _internalController.addListener(() {
      // Si el callback onChanged existe, lo llamamos con el texto actual.
      widget.onChanged?.call(_internalController.text);
    });
  }

  @override
  void dispose() {
    // 5. Solo hacemos dispose del controller si lo creamos nosotros.
    // Si vino de afuera, la pantalla padre es responsable de él.
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return SizedBox(
      height: isMobile ? 50 : 45,
      width: isMobile
          ? MediaQuery.of(context).size.width * 0.5
          : MediaQuery.of(context).size.width * 0.2,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _internalController,
            decoration: InputDecoration(
              hintText: 'Buscar',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 18),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
            ),
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
