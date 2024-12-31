import 'package:simple_geocam/template/transport/value/altitude_type.dart';
import 'package:simple_geocam/template/transport/value/temperature_type.dart';
import 'package:simple_geocam/template/transport/value/wind_type.dart';

class TemplateWeatherTransport {
  final bool hasTemperature;
  TemperatureType temperatureType;
  final bool hasWind;
  WindType windType;
  final bool hasCompass;
  final bool hasHumidity;
  final bool hasAltitude;
  AltitudeType altitudeType;
  final bool hasMagneticField;

  TemplateWeatherTransport(
      {required this.hasTemperature,
      required this.hasWind,
      required this.hasCompass,
      required this.hasHumidity,
      required this.hasAltitude,
      required this.hasMagneticField,
      this.temperatureType = TemperatureType.celsius,
      this.windType = WindType.kmph,
      this.altitudeType = AltitudeType.feet});

  // Factory constructor to create an instance from JSON
  factory TemplateWeatherTransport.fromJson(Map<String, dynamic> json) {
    return TemplateWeatherTransport(
      hasTemperature: json['hasTemperature'] as bool,
      hasWind: json['hasWind'] as bool,
      hasCompass: json['hasCompass'] as bool,
      hasHumidity: json['hasHumidity'] as bool,
      hasAltitude: json['hasAltitude'] as bool,
      hasMagneticField: json['hasMagneticField'] as bool,
      temperatureType: json['temperatureType'] as TemperatureType,
      windType: json['windType'] as WindType,
      altitudeType: json['altitudeType'] as AltitudeType,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'hasTemperature': hasTemperature,
      'hasWind': hasWind,
      'hasCompass': hasCompass,
      'hasHumidity': hasHumidity,
      'hasAltitude': hasAltitude,
      'hasMagneticField': hasMagneticField,
      'temperatureType': temperatureType,
      'windType': windType,
      'altitudeType': altitudeType,
    };
  }
}
