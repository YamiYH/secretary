class MinistryModel {
  final String id;
  String name;
  final String details;
  final List<String> pastorIds;

  MinistryModel({
    required this.id,
    required this.name,
    required this.details,
    this.pastorIds = const [],
  });

  MinistryModel copyWith({
    String? id,
    String? name,
    String? details,
    List<String>? pastorIds,
  }) {
    return MinistryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
      pastorIds: pastorIds ?? this.pastorIds,
    );
  }
}
