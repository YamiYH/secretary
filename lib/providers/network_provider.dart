import 'package:flutter/material.dart';

import '../models/network_model.dart';

class NetworkProvider with ChangeNotifier {
  // Lista de ejemplo. En el futuro, esto vendrá de una base de datos.
  final List<NetworkModel> _networks = [
    NetworkModel(id: 'n1', name: 'Jóvenes', ageRange: '15 a 35 años'),
    NetworkModel(id: 'n2', name: 'Mujeres', ageRange: ''),
    NetworkModel(id: 'n3', name: 'Hombres', ageRange: ''),
    NetworkModel(id: 'n4', name: 'Niños', ageRange: ''),
    NetworkModel(id: 'n5', name: 'Juveniles', ageRange: ''),
    NetworkModel(id: 'n6', name: '3ra Edad', ageRange: ''),
  ];

  List<NetworkModel> get networks => [..._networks];

  void addNetwork(NetworkModel network) {
    final newNetwork = NetworkModel(
      id: DateTime.now().toString(), // ID único simple
      name: network.name,
      ageRange: network.ageRange,
    );
    _networks.add(newNetwork);
    notifyListeners(); // Notifica a los widgets que escuchan para que se redibujen
  }

  void updateNetwork(NetworkModel updatedNetwork) {
    final networkIndex = _networks.indexWhere(
      (net) => net.id == updatedNetwork.id,
    );
    if (networkIndex >= 0) {
      _networks[networkIndex] = updatedNetwork;
      notifyListeners();
    }
  }

  void deleteNetwork(String networkId) {
    _networks.removeWhere((net) => net.id == networkId);
    notifyListeners();
  }
}
