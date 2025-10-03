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
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(isMobile ? 'assets/06.png' : 'assets/03.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: isMobile ? 200 : 50),
              isMobile
                  ? Column(
                      children: [
                        Text(
                          'Secretaría',
                          textAlign: TextAlign.center,
                          style: _mobileTextStyle(),
                        ),
                        Text(
                          'Viento Recio',
                          textAlign: TextAlign.center,
                          style: _mobileTextStyle(),
                        ),
                      ],
                    )
                  : Text(
                      'Bienvenido a la Secretaría de Viento Recio',
                      textAlign: TextAlign.center,
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
              SizedBox(height: isMobile ? 120 : 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isMobile ? Colors.blueAccent : Colors.white,
                  elevation: isMobile ? 5 : 20,
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
                      style: TextStyle(
                        color: isMobile ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.login,
                      color: isMobile ? Colors.white : Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _mobileTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 34,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(color: Colors.white, offset: Offset(3, 3), blurRadius: 7),
      ],
    );
  }
}
