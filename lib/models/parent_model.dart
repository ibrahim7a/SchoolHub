class ParentModel {
  final String id;
  final String name;
  final String phone;
  final String studentId;

  ParentModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.studentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'studentId': studentId,
    };
  }

  factory ParentModel.fromMap(
      String id, Map<String, dynamic> map) {
    return ParentModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      studentId: map['studentId'] ?? '',
    );
  }
}