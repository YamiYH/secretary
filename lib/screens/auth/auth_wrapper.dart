// lib/screens/auth/auth_wrapper.dart

import 'package:app/screens/home/dashboard.dart';
import 'package:flutter/material.dart';

import '../../screens/home/home.dart'; // La pantalla principal de tu app
import '../../services/auth_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      // Comprobamos si existe un token guardado
      future: _authService.getToken(),
      builder: (context, snapshot) {
        // Mientras se comprueba, muestra un indicador de carga
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Si el snapshot tiene datos (el token no es nulo), el usuario está logueado
        if (snapshot.hasData && snapshot.data != null) {
          return const Dashboard(); // Muestra la pantalla principal
        }

        // Si no hay token, muestra la pantalla de login
        return const Home();
      },
    );
  }
}
