// lib/models/member_model.dart

class Member {
  final String id;
  final String name;
  final String lastName;
  final String phone;
  final String address;
  final String birthDate;
  final String group;

  Member({
    required this.id,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.birthDate,
    required this.group,
  });
}
