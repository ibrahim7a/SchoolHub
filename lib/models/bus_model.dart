class BusModel {
  final String id;
  final String busNumber;
  final String driverName;
  final double latitude;
  final double longitude;
  final String status;

  BusModel({
    required this.id,
    required this.busNumber,
    required this.driverName,
    required this.latitude,
    required this.longitude,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'busNumber': busNumber,
      'driverName': driverName,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  factory BusModel.fromMap(
      String id, Map<String, dynamic> map) {
    return BusModel(
      id: id,
      busNumber: map['busNumber'] ?? '',
      driverName: map['driverName'] ?? '',
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      status: map['status'] ?? '',
    );
  }
}