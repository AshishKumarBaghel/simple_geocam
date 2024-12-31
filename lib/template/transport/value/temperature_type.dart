enum TemperatureType {
  celsius("Celsius", "°C"),       // Celsius format
  fahrenheit("Fahrenheit", "°F"); // Fahrenheit format

  final String displayName;
  final String unit;

  const TemperatureType(this.displayName, this.unit);

  /// Converts and formats the temperature value based on the selected type
  String format(double temperature, {TemperatureType to = TemperatureType.celsius}) {
    double convertedTemp = this == TemperatureType.celsius
        ? (to == TemperatureType.celsius ? temperature : _toFahrenheit(temperature))
        : (to == TemperatureType.fahrenheit ? temperature : _toCelsius(temperature));
    return "${convertedTemp.toStringAsFixed(2)} $unit";
  }

  /// Converts Celsius to Fahrenheit
  double _toFahrenheit(double celsius) {
    return celsius * 9 / 5 + 32;
  }

  /// Converts Fahrenheit to Celsius
  double _toCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
}