import 'package:simple_geocam/transport/geo_cam_address_transport.dart';
import 'package:simple_geocam/transport/geo_cam_weather_transport.dart';

class GeoCamTransport {
  final GeoCamAddressTransport address;
  final GeoCamWeatherTransport weather;

  GeoCamTransport({
    required this.address,
    required this.weather,
  });

  // Factory constructor to create an instance from JSON
  factory GeoCamTransport.fromJson(Map<String, dynamic> json) {
    return GeoCamTransport(
      address: json['address'] as GeoCamAddressTransport,
      weather: json['weather'] as GeoCamWeatherTransport,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'weather': weather,
    };
  }
}
