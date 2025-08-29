import 'package:app/screens/attendance.dart';
import 'package:app/screens/dashboard.dart';
import 'package:app/screens/members.dart';
import 'package:app/screens/profile.dart';
import 'package:app/screens/services.dart';
import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/login.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = 'login';
  static const String profile = 'profile';
  static const String dashboard = 'dashboard';
  static const String services = 'services';
  static const String members = 'members';
  static const String attendance = 'attendance';

  static Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      home: (context) => Home(),
      login: (context) => Login(),
      profile: (context) => Profile(),
      dashboard: (context) => Dashboard(),
      services: (context) => Services(),
      members: (context) => Members(),
      attendance: (context) => Attendance(),
    };
  }
}
