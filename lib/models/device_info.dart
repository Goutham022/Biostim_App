class DeviceInfo {
  final String model;
  final String serial;
  final int battery;

  DeviceInfo({
    required this.model,
    required this.serial,
    required this.battery,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      model: json['model'] ?? '',
      serial: json['serial'] ?? '',
      battery: json['battery'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'serial': serial,
      'battery': battery,
    };
  }

  @override
  String toString() {
    return 'DeviceInfo(model: $model, serial: $serial, battery: $battery%)';
  }
} 