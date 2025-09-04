import 'package:app/screens/attendance.dart';
import 'package:app/screens/create_network.dart';
import 'package:app/screens/dashboard.dart';
import 'package:app/screens/members.dart';
import 'package:app/screens/profile.dart';
import 'package:app/screens/services.dart';
import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/networks.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = 'login';
  static const String profile = 'profile';
  static const String dashboard = 'dashboard';
  static const String services = 'services';
  static const String members = 'members';
  static const String attendance = 'attendance';
  static const String networks = 'networks';
  static const String create_network = 'create_network';

  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      home: (context) => Home(),
      login: (context) => Login(),
      profile: (context) => Profile(),
      dashboard: (context) => Dashboard(),
      services: (context) => Services(),
      members: (context) => Members(),
      attendance: (context) => Attendance(),
      networks: (context) => Networks(),
      create_network: (context) => CreateNetwork(),
    };
  }
}
