import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';
import '../../widgets/button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);

    final authService = Provider.of<AuthService>(context, listen: false);

    final error = await authService.signIn(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
        );
      } else {
        Navigator.push(context, createFadeRoute(Dashboard()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      // Evita que el contenido se redimensione cuando el teclado aparece.
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: isMobile ? Colors.grey.shade400 : Colors.transparent,
          image: DecorationImage(
            image: AssetImage(isMobile ? 'assets/01.jpg' : 'assets/05.png'),
            fit: BoxFit.fill,
            opacity: 0.25,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey, // Asigna la clave al formulario
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/logo.png', height: 150),
                        const SizedBox(height: 50),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_android),
                                  labelText: 'Nombre de usuario',
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                        BorderSide.none, // Sin borde visible
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    // Borde cuando el campo está enfocado
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                        BorderSide.none, // Sin borde visible
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    // Borde cuando el campo está habilitado
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                        BorderSide.none, // Sin borde visible
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 15.0,
                                  ), //
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                  ), // Padding interno
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingresa tu nombre de usuario';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ), // Espacio entre campos

                              TextFormField(
                                controller: _passwordController,
                                obscureText: true, // Para ocultar la contraseña
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  labelText: 'Contraseña',
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  labelStyle: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingresa tu contraseña';
                                  }
                                  if (value.length < 3) {
                                    return 'La contraseña debe tener al menos 3 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : Button(
                                      text: 'Iniciar sesión',
                                      onPressed: _handleLogin,
                                      size: Size(400, 45),
                                    ),
                              const SizedBox(height: 20),

                              TextButton(
                                onPressed: () {
                                  // Lógica para recuperar contraseña
                                  print('Olvidé mi contraseña presionado');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Funcionalidad de recuperación de contraseña en desarrollo.',
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                },
                                child: const Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
