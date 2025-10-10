import 'package:app/screens/dashboard.dart';
import 'package:app/screens/home.dart';
import 'package:flutter/material.dart';

import '../routes/page_route_builder.dart';
import '../screens/profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  final bool isDrawerEnabled;

  CustomAppBar({
    Key? key,
    required this.title,
    this.bottom,
    this.isDrawerEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    final bool canGoBack = Navigator.canPop(context);

    Widget leadingWidget;

    if (isMobile && isDrawerEnabled) {
      // 1. En móvil y con Drawer, forzamos el ícono de Menú.
      leadingWidget = Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      );
    } else if (canGoBack) {
      // 2. Si NO hay Drawer o es Web, y podemos volver, mostramos la flecha de atrás.
      leadingWidget = const BackButton(color: Colors.white);
    } else {
      // 3. En caso contrario (Web, sin atrás, sin Drawer), un espacio vacío.
      leadingWidget = const SizedBox(width: 56.0);
    }

    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.blue.shade800,
      titleSpacing: 0,

      automaticallyImplyLeading: false,

      // 3. Definimos el widget 'leading' con nuestra lógica condicional.
      leading: leadingWidget,

      // Si no, muestra un espacio invisible del mismo ancho.
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: isMobile ? 16 : 18),
          ),
          SizedBox(width: isMobile ? 5 : 20),
          IconButton(
            tooltip: 'Página principal',
            onPressed: () {
              Navigator.push(context, createFadeRoute(Dashboard()));
            },
            icon: Icon(Icons.home),
          ),
          IconButton(
            tooltip: 'Manual de Usuarios',
            onPressed: () {},
            icon: Icon(Icons.help_outline),
          ),
          //SizedBox(width: isMobile ? 10 : 20),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  createFadeRoute(Profile()),
                ); // Navegar a editar perfil
              } else if (value == 'logout') {
                Navigator.push(
                  context,
                  createFadeRoute(Home()),
                ); // Navegar a editar perfil
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'profile', child: Text('Mi Perfil')),
              PopupMenuItem(value: 'logout', child: Text('Cerrar Sesión')),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: isMobile ? 22 : 25,
            ),
          ),
        ],
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    // Suma la altura del bottom si está presente
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
