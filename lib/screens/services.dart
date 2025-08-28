import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/menu.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  int _selectedIndex =
      0; // Índice seleccionado para la barra de navegación inferior

  final List<Service> _upcomingServices = [
    Service(title: 'Culto Matutino', date: 'Domingo, 21 de Julio de 2024'),
    Service(
      title: 'Servicio de Mitad de Semana',
      date: 'Miércoles, 24 de Julio de 2024',
    ),
    Service(title: 'Convivencia Juvenil', date: 'Viernes, 26 de Julio de 2024'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Aquí podrías manejar la navegación a diferentes pantallas
    // Por ahora, solo actualiza el índice seleccionado.
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo gris claro
      appBar: CustomAppBar(title: 'Servicios'),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: isMobile
          ? SingleChildScrollView(
              // Contenido principal de Servicios para móvil
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildServicesContent(), // Contenido de servicios
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Menu(),
                // Contenido principal de Servicios
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: _buildServicesContent(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Column _buildServicesContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sección de Próximos Servicios
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12), // Esquinas redondeadas
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2.5,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Próximos Servicios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  AddButton(
                    onPressed: () {},
                    text: 'Servicio',
                    size: Size(150, 45),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Lista de servicios
              ListView.separated(
                shrinkWrap: true, // Importante para ListView dentro de Column
                physics:
                    const NeverScrollableScrollPhysics(), // Deshabilita el scroll del ListView interno
                itemCount: _upcomingServices.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 0.2, // Línea de separación más fina
                  indent: 0,
                  endIndent: 0,
                ),
                itemBuilder: (context, index) {
                  final service = _upcomingServices[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              service.date,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue.shade700,
                                size: 22,
                              ),
                              tooltip: 'Editar Receta',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade700,
                                size: 22,
                              ),
                              tooltip: 'Eliminar Receta',
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Service {
  final String title;
  final String date;

  Service({required this.title, required this.date});
}
