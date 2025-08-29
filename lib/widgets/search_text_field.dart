import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  final Function(String)? onChanged;
  final TextEditingController? controller;

  final String? Function(String?)? validator;
  SearchTextField({
    super.key,
    this.onChanged,
    required this.controller,
    this.validator,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
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
            controller: widget.controller,
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
