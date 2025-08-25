import 'package:flutter/material.dart';

import '../routes/page_route_builder.dart';
import '../screens/profile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;

  CustomAppBar({Key? key, required this.title, this.bottom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final profileProvider = Provider.of<ProfileProvider>(context);
    // final user = profileProvider.userProfile;
    bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool canGoBack = Navigator.canPop(context);

    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.red[900],
      titleSpacing: 0,

      automaticallyImplyLeading: false,

      // 3. Definimos el widget 'leading' con nuestra lógica condicional.
      leading: canGoBack
          ? const BackButton(
              color: Colors.white,
            ) // Si podemos volver, muestra el botón.
          : const SizedBox(width: 56.0),

      // Si no, muestra un espacio invisible del mismo ancho.
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: isMobile
                ? SizedBox()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/icons/user.png'),
                        radius: 16,
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: isMobile
                            ? 80
                            : MediaQuery.of(context).size.width * 0.1,
                        child: Text(
                          'Login',
                          //  user?.name ?? 'Cargando...',
                          //  overflow: TextOverflow.clip,
                          //  style: TextStyle(
                          //    color: Colors.white,
                          //    fontSize: isMobile
                          //      ? 13
                          //       : MediaQuery.of(context).size.width * 0.011,
                          // ),
                        ),
                      ),
                    ],
                  ),
          ),
          //SizedBox(width: isMobile ? 0 : 60),
          Expanded(
            flex: isMobile ? 12 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 16 : 18,
                  ),
                ),
                SizedBox(width: isMobile ? 5 : 20),
                IconButton(
                  tooltip: 'Página principal',
                  onPressed: () {},
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
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'profile', child: Text('Mi Perfil')),
                    PopupMenuItem(
                      value: 'logout',
                      child: Text('Cerrar Sesión'),
                    ),
                  ],
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: isMobile ? 22 : 25,
                  ),
                ),
              ],
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
