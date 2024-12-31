enum AltitudeType {
  meter("Meters", "m"), // Altitude in meters
  feet("Feet", "ft");   // Altitude in feet

  final String displayName;
  final String unit;

  const AltitudeType(this.displayName, this.unit);

  /// Converts and formats the altitude value based on the selected type
  String format(double altitude, {AltitudeType to = AltitudeType.meter}) {
    double convertedAltitude = _convert(altitude, from: this, to: to);
    return "${convertedAltitude.toStringAsFixed(2)} $unit";
  }

  /// Conversion logic for altitude between meters and feet
  double _convert(double altitude, {required AltitudeType from, required AltitudeType to}) {
    if (from == to) return altitude;

    // Conversion logic
    return from == AltitudeType.meter
        ? altitude * 3.28084 // Meters to feet
        : altitude / 3.28084; // Feet to meters
  }
}