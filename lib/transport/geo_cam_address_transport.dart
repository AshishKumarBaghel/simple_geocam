class GeoCamAddressTransport {
  final String addressTitle;
  final String address;
  final double lat;
  final double long;
  final DateTime dateTime;

  GeoCamAddressTransport({
    required this.addressTitle,
    required this.address,
    required this.lat,
    required this.long,
    required this.dateTime,
  });

  // Factory constructor to create an instance from JSON
  factory GeoCamAddressTransport.fromJson(Map<String, dynamic> json) {
    return GeoCamAddressTransport(
      addressTitle: json['addressTitle'] as String,
      address: json['address'] as String,
      lat: json['lat'] as double,
      long: json['long'] as double,
      dateTime: json['dateTime'] as DateTime,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'addressTitle': addressTitle,
      'address': address,
      'lat': lat,
      'long': long,
      'dateTime': dateTime,
    };
  }
}
