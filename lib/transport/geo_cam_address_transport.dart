class GeoCamAddressTransport {
  final String addressTitle;
  final String address;
  final String lat;
  final String lon;
  final DateTime dateTime;

  GeoCamAddressTransport({
    required this.addressTitle,
    required this.address,
    required this.lat,
    required this.lon,
    required this.dateTime,
  });

  // Factory constructor to create an instance from JSON
  factory GeoCamAddressTransport.fromJson(Map<String, dynamic> json) {
    return GeoCamAddressTransport(
      addressTitle: json['addressTitle'] as String,
      address: json['address'] as String,
      lat: json['lat'] as String,
      lon: json['lon'] as String,
      dateTime: json['dateTime'] as DateTime,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'addressTitle': addressTitle,
      'address': address,
      'lat': lat,
      'lon': lon,
      'dateTime': dateTime,
    };
  }
}
