import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/login.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/03.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 50),
              Text(
                'Bienvenido a la Secretaría de Viento Recio',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(3, 3),
                      blurRadius: 7,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 20,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 20,
                  ),
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, createFadeRoute(Login()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.login, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
