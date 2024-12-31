import 'package:simple_geocam/template/transport/template_address_transport.dart';
import 'package:simple_geocam/template/transport/template_map_transport.dart';
import 'package:simple_geocam/template/transport/template_weather_transport.dart';

class TemplateTransport {
  final TemplateMapTransport templateMap;
  final TemplateAddressTransport templateAddress;
  final TemplateWeatherTransport templateWeather;

  TemplateTransport({
    required this.templateMap,
    required this.templateAddress,
    required this.templateWeather,
  });

  // Factory constructor to create an instance from JSON
  factory TemplateTransport.fromJson(Map<String, dynamic> json) {
    return TemplateTransport(
      templateMap: json['templateMap'] as TemplateMapTransport,
      templateAddress: json['templateAddress'] as TemplateAddressTransport,
      templateWeather: json['templateWeather'] as TemplateWeatherTransport,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'templateMap': templateMap,
      'templateAddress': templateAddress,
      'templateWeather': templateWeather,
    };
  }
}
