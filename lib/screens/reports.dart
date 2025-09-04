import 'package:app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../widgets/menu.dart'; // Tu widget de menú lateral

// 1. Widget principal de la pantalla de Reportes
class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Reportes'),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMobile) const SizedBox(child: Menu()),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Contenido para la pestaña "Resúmenes de asistencia"
                ReportContent(),
                // Placeholder para las otras pestañas
                const Center(child: Text('Estadísticas de Miembros')),
                const Center(child: Text('Participación en Eventos')),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              // ... (código de BottomNavigationBar que ya tienes)
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_outlined),
                  label: 'Miembros',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month_outlined),
                  label: 'Servicios',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.how_to_reg_outlined),
                  label: 'Asistencia',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on_outlined),
                  label: 'Visitas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.description_outlined),
                  label: 'Reportes',
                ),
              ],
            )
          : null,
    );
  }
}

// 2. Widget para el contenido de los reportes
class ReportContent extends StatelessWidget {
  const ReportContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          const Text(
            'Asistencia Total',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tendencia de Asistencia',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          // Métrica principal
          const Text(
            '1,250',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Últimos 30 días +15%',
            style: TextStyle(fontSize: 16, color: Colors.green),
          ),
          const SizedBox(height: 32),
          // Gráfico de tendencia (puedes usar un paquete como fl_chart)
          Container(
            height: 150,
            color: Colors.grey[200],
            child: const Center(child: Text('Gráfico de Líneas Aquí')),
          ),
          const SizedBox(height: 32),
          // Sección de Asistencia por Grupo
          const Text(
            'Asistencia por Grupo',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildGroupBar('Jóvenes', 250),
          _buildGroupBar('Adultos', 300),
          _buildGroupBar('Mayores', 400),
          _buildGroupBar('Niños', 300),
          const SizedBox(height: 32),
          // Filtros
          Row(
            children: [
              _buildFilterButton('Rango de Fecha'),
              const SizedBox(width: 16),
              _buildFilterButton('Grupo'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupBar(String title, int attendance) {
    // La lógica de la barra podría ser más compleja
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value:
                    attendance /
                    1250, // Ejemplo de cálculo, ajusta según tus datos
                minHeight: 20,
                backgroundColor: Colors.grey[300],
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '$attendance',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text(text),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, size: 18),
        ],
      ),
    );
  }
}

// Asegúrate de que los colores y otros widgets están definidos en sus archivos correspondientes
const primaryColor1 = Colors.blue;
const secondaryColor = Colors.grey;
const accentColor = Colors.green;
const backgroundColor = Color(0xFFF3F5F9);
