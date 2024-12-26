class GeoCamTransport {
  final String addressTitle;
  final String address;
  final String lat;
  final String lon;
  final DateTime dateTime;
  final String note;

  GeoCamTransport({
    required this.addressTitle,
    required this.address,
    required this.lat,
    required this.lon,
    required this.dateTime,
    required this.note,
  });

  // Factory constructor to create an instance from JSON
  factory GeoCamTransport.fromJson(Map<String, dynamic> json) {
    return GeoCamTransport(
      addressTitle: json['addressTitle'] as String,
      address: json['address'] as String,
      lat: json['lat'] as String,
      lon: json['lon'] as String,
      dateTime: json['dateTime'] as DateTime,
      note: json['note'] as String,
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
      'note': note,
    };
  }
}
