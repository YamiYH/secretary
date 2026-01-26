class NetworkModel {
  final String id;
  String name;
  final String ageRange;
  final List<String> pastorIds;

  NetworkModel({
    required this.id,
    required this.name,
    this.ageRange = '',
    this.pastorIds = const [],
  });

  NetworkModel copyWith({
    String? id,
    String? name,
    String? ageRange,
    List<String>? pastorIds,
  }) {
    return NetworkModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ageRange: ageRange ?? this.ageRange,
      pastorIds: pastorIds ?? this.pastorIds,
    );
  }
}
