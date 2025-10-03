import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/menu.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

// Widget para las tarjetas de métricas en la parte superior del dashboard
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final Color percentageColor;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.percentageColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: percentageColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para los elementos de lista en las secciones
class DashboardListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const DashboardListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryColor, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: secondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Clase principal del Dashboard
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    // Contenido principal del dashboard (tarjetas y listas)
    final Widget mainContent = MediaQuery.removePadding(
      context: context,
      removeTop: isMobile ? false : true,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de Métricas (tarjetas en un GridView para responsividad)
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 900
                      ? 3
                      : constraints.maxWidth > 700
                      ? 2
                      : 1;

                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isMobile ? 1.5 : 1.7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const MetricCard(
                        title: 'Total de miembros',
                        value: '1,250',
                        percentage: '+10%',
                        percentageColor: accentColor,
                      ),
                      const MetricCard(
                        title: 'Miembros nuevos',
                        value: '125',
                        percentage: '+25%',
                        percentageColor: accentColor,
                      ),
                      const MetricCard(
                        title: 'Miembros activos',
                        value: '1,100',
                        percentage: '+5%',
                        percentageColor: accentColor,
                      ),
                    ],
                  );
                },
              ),

              // const SizedBox(height: 30),
              isMobile
                  ? SizedBox(height: 0, width: 0)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Servicios',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                        ),
                        Divider(),
                        const SizedBox(height: 16),
                        const DashboardListItem(
                          icon: Icons.calendar_month_outlined,
                          title: 'Celebración',
                          subtitle: 'Domingo, 9:00 AM',
                        ),
                        const DashboardListItem(
                          icon: Icons.calendar_month_outlined,
                          title: 'Adoración',
                          subtitle: 'Martes, 7:00 PM',
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );

    // Menú lateral para vista web

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Inicio'),
      body: isMobile
          ? mainContent
          : Row(
              children: [
                Menu(),
                Expanded(child: mainContent),
              ],
            ),
      drawer: isMobile
          ? Drawer(child: Menu())
          : null, // El Drawer solo en móvil
    );
  }
}
