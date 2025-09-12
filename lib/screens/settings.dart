// En tu archivo 'settings_screen.dart'
import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Configuración'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 600
              ? _buildMobileLayout()
              : _buildWebLayout();
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSettingTile('Notificaciones', Icons.notifications, true),
          _buildSettingTile('Modo Oscuro', Icons.dark_mode, false),
          _buildSettingTile('Acerca de', Icons.info_outline),
          _buildSettingTile('Cerrar Sesión', Icons.logout),
        ],
      ),
    );
  }

  Widget _buildWebLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: SizedBox(
          width: 800,
          child: Card(
            elevation: 5,
            child: Column(
              children: [
                _buildSettingTile('Notificaciones', Icons.notifications, true),
                _buildSettingTile('Modo Oscuro', Icons.dark_mode, false),
                _buildSettingTile('Acerca de', Icons.info_outline),
                _buildSettingTile('Cerrar Sesión', Icons.logout),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    IconData icon, [
    bool showSwitch = false,
  ]) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: showSwitch
          ? Switch(
              value: true, // Debes manejar el estado con setState
              onChanged: (bool value) {
                print('Switch cambiado a $value');
              },
            )
          : const Icon(Icons.chevron_right),
      onTap: () {
        print('Presionaste: $title');
      },
    );
  }
}
