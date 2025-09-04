import 'package:app/screens/attendance.dart';
import 'package:app/screens/create/create_network.dart';
import 'package:app/screens/create/create_service.dart';
import 'package:app/screens/dashboard.dart';
import 'package:app/screens/members.dart';
import 'package:app/screens/ministries.dart';
import 'package:app/screens/profile.dart';
import 'package:app/screens/reports.dart';
import 'package:app/screens/services.dart';
import 'package:flutter/material.dart';

import '../screens/create/create_ministry.dart';
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
  static const String ministries = 'ministries';
  static const String create_ministry = 'create_ministry';
  static const String reports = 'reports';
  static const String create_service = 'create_service';

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
      ministries: (context) => Ministries(),
      create_ministry: (context) => CreateMinistry(),
      reports: (context) => Reports(),
      create_service: (context) => CreateService(),
    };
  }
}
