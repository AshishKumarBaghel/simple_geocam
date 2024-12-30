class GeoCamWeatherTransport {
  final String temperature;
  final String wind;
  final String altitude;
  final String compass;
  final String humidity;
  final String magneticField;

  GeoCamWeatherTransport({
    required this.temperature,
    required this.wind,
    required this.altitude,
    required this.compass,
    required this.humidity,
    required this.magneticField,
  });

  // Factory constructor to create an instance from JSON
  factory GeoCamWeatherTransport.fromJson(Map<String, dynamic> json) {
    return GeoCamWeatherTransport(
      temperature: json['temperature'] as String,
      wind: json['wind'] as String,
      altitude: json['altitude'] as String,
      compass: json['compass'] as String,
      humidity: json['humidity'] as String,
      magneticField: json['magneticField'] as String,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'wind': wind,
      'altitude': altitude,
      'compass': compass,
      'humidity': humidity,
      'magneticField': magneticField,
    };
  }
}
