import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/dashboard.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controladores para los campos de texto de email y contraseña.
  // Son útiles para acceder al texto ingresado por el usuario y para limpiar los campos.
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Clave global para el formulario, usada para validar los campos.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Es importante desechar los controladores cuando el widget se destruye
    // para liberar recursos y evitar fugas de memoria.
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función simulada para el proceso de inicio de sesión.
  void _login() {
    // Valida todos los campos del formulario.
    if (_formKey.currentState!.validate()) {
      // Si el formulario es válido, puedes acceder a los valores ingresados.
      final String phone = _phoneController.text;
      final String password = _passwordController.text;

      // Aquí iría tu lógica real de autenticación (ej. llamar a una API, Firebase, etc.).
      // Por ahora, solo imprimimos los valores.
      print('Email: $phone, Contraseña: $password');

      // Puedes mostrar un mensaje de éxito o navegar a otra pantalla.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Iniciando sesión con $phone...'),
          backgroundColor: Colors.blueAccent,
        ),
      );
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
            image: AssetImage(isMobile ? 'assets/01.png' : 'assets/05.png'),
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
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.phone_android),
                                  labelText: 'Teléfono',
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
                                    return 'Por favor, ingresa tu número de teléfono';
                                  }
                                  // Validar que sean exactamente 8 dígitos numéricos
                                  if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
                                    return 'Introduzca un teléfono válido';
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
                                  if (value.length < 6) {
                                    return 'La contraseña debe tener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),

                              Button(
                                text: 'Iniciar sesión',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    createFadeRoute(Dashboard()),
                                  );
                                },
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
