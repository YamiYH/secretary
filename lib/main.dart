import 'package:app/providers/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'routes/routes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ServiceProvider(),
      child: const MyApp(), // O como se llame tu widget principal
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
      locale: const Locale(
        'es',
        '',
      ), // Establece el idioma por defecto a español
    );
  }
}
