class DriverModel {
  final String id;
  final String name;
  final String phone;
  final String licenseNumber;
  final String assignedBusId;
  final String status;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.licenseNumber,
    required this.assignedBusId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'licenseNumber': licenseNumber,
      'assignedBusId': assignedBusId,
      'status': status,
    };
  }

  factory DriverModel.fromMap(
      String id,
      Map<String, dynamic> map,
      ) {
    return DriverModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      assignedBusId: map['assignedBusId'] ?? '',
      status: map['status'] ?? 'Offline',
    );
  }
}