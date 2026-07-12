class StudentModel {
  final String id;
  final String name;
  final String className;
  final String busId;
  final String parentId;

  StudentModel({
    required this.id,
    required this.name,
    required this.className,
    required this.busId,
    required this.parentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'className': className,
      'busId': busId,
      'parentId': parentId,
    };
  }

  factory StudentModel.fromMap(
      String id, Map<String, dynamic> map) {
    return StudentModel(
      id: id,
      name: map['name'] ?? '',
      className: map['className'] ?? '',
      busId: map['busId'] ?? '',
      parentId: map['parentId'] ?? '',
    );
  }
}