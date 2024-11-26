class VpnLocation {
  final String id;
  final String country;
  final String city;
  final String flag;
  final String serverAddress;
  final double latitude;
  final double longitude;
  final int ping;

  VpnLocation({
    required this.id,
    required this.country,
    required this.city,
    required this.flag,
    required this.serverAddress,
    required this.latitude,
    required this.longitude,
    this.ping = 0,
  });

  factory VpnLocation.fromJson(Map<String, dynamic> json) {
    return VpnLocation(
      id: json['id'],
      country: json['country'],
      city: json['city'],
      flag: json['flag'],
      serverAddress: json['serverAddress'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      ping: json['ping'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'city': city,
      'flag': flag,
      'serverAddress': serverAddress,
      'latitude': latitude,
      'longitude': longitude,
      'ping': ping,
    };
  }
}
