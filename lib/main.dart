// main.dart

import 'package:app/providers/attendance_provider.dart';
import 'package:app/providers/log_provider.dart';
import 'package:app/providers/member_provider.dart';
import 'package:app/providers/ministry_provider.dart';
import 'package:app/providers/network_provider.dart';
import 'package:app/providers/role_provider.dart';
import 'package:app/providers/service_provider.dart';
import 'package:app/providers/service_type_provider.dart';
// 1. Importa el nuevo UserProvider que creamos
import 'package:app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'routes/routes.dart';

void main() {
  runApp(
    // 2. Reemplaza ChangeNotifierProvider por MultiProvider
    MultiProvider(
      providers: [
        // 3. Registra aquí todos tus proveedores
        ChangeNotifierProvider(create: (context) => ServiceProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => RoleProvider()),
        ChangeNotifierProvider(create: (context) => LogProvider()),
        ChangeNotifierProvider(create: (context) => MemberProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(create: (context) => NetworkProvider()),
        ChangeNotifierProvider(create: (context) => MinistryProvider()),
        ChangeNotifierProvider(create: (context) => ServiceTypeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secretaría Viento Recio',
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Inglés
        Locale('es', ''), // Español
      ],
      locale: const Locale('es', ''),
    );
  }
}
