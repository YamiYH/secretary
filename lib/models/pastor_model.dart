class PastorModel {
  final String id;
  final String name;

  const PastorModel({required this.id, required this.name});

  factory PastorModel.fromJson(Map<String, dynamic> json) {
    return PastorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Sin nombre',
    );
  }

  // También es buena idea reforzar el método toJson si lo tienes
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
