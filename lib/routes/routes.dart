import 'package:app/screens/profile.dart';
import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/login.dart';

class AppRoutes {
  // Definimos los nombres de las rutas
  static const String home = '/';
  static const String login = 'login';
  static const String profile = 'profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      home: (context) => Home(),
      login: (context) => Login(),
      profile: (context) => Profile(),
    };
  }
}
