import 'package:app/routes/page_route_builder.dart';
import 'package:app/screens/create/create_service.dart';
import 'package:app/widgets/add_button.dart';
import 'package:app/widgets/custom_appbar.dart';
import 'package:app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../colors.dart';
import '../providers/service_provider.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(title: 'Servicios', isDrawerEnabled: isMobile),
      drawer: isMobile ? Drawer(child: Menu()) : null,
      body: isMobile
          ? SingleChildScrollView(
              // Contenido principal de Servicios para móvil
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildServicesContent(
                  isMobile,
                ), // Contenido de servicios
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
                      child: _buildServicesContent(isMobile),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Column _buildServicesContent(isMobile) {
    final servicesProvider = Provider.of<ServiceProvider>(context);
    final upcomingServices = servicesProvider.services;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
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
                  Text(
                    isMobile ? 'Servicios' : 'Próximos Servicios',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  AddButton(
                    onPressed: () {
                      Navigator.push(context, createFadeRoute(CreateService()));
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Lista de servicios
              ListView.separated(
                shrinkWrap: true, // Importante para ListView dentro de Column
                physics:
                    const NeverScrollableScrollPhysics(), // Deshabilita el scroll del ListView interno
                itemCount: upcomingServices.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 0.2, // Línea de separación más fina
                  indent: 0,
                  endIndent: 0,
                ),
                itemBuilder: (context, index) {
                  final service = upcomingServices[index];
                  final DateFormat dateFormatter = DateFormat(
                    'EEEE, dd \'de\' MMMM \'de\' yyyy',
                    'es',
                  );
                  final String formattedDate = dateFormatter.format(
                    service.date,
                  );

                  final String formattedTime =
                      '${service.time.hourOfPeriod}:${service.time.minute.toString().padLeft(2, '0')} ${service.time.period == DayPeriod.am ? 'A.M.' : 'P.M.'}';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: isMobile ? 200 : 400,
                          child: Column(
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
                                '$formattedDate a las $formattedTime',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue.shade700,
                                size: 22,
                              ),
                              tooltip: 'Editar servicio',
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red.shade700,
                                size: 22,
                              ),
                              tooltip: 'Eliminar servicio',
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
