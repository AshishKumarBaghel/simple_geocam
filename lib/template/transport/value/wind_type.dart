enum WindType {
  kmph("Kilometers per Hour", "km/h"), // Kilometers per hour
  mph("Miles per Hour", "mph"), // Miles per hour
  mps("Meters per Second", "m/s"), // Meters per second
  kt("Knots", "kt"); // Knots

  final String displayName;
  final String unit;

  const WindType(this.displayName, this.unit);

  /// Converts and formats the wind speed value based on the selected type
  String format(double speed, {WindType to = WindType.kmph}) {
    double convertedSpeed = _convert(speed, from: this, to: to);
    return "${convertedSpeed.toStringAsFixed(2)} $unit";
  }

  /// Conversion logic for wind speed between different units
  double _convert(double speed, {required WindType from, required WindType to}) {
    if (from == to) return speed;

    // Convert to meters per second (mps) as a base unit
    double speedInMps = from == WindType.kmph
        ? speed / 3.6
        : from == WindType.mph
            ? speed * 0.44704
            : from == WindType.kt
                ? speed * 0.514444
                : speed; // Already in mps

    // Convert from meters per second to the target unit
    return to == WindType.kmph
        ? speedInMps * 3.6
        : to == WindType.mph
            ? speedInMps / 0.44704
            : to == WindType.kt
                ? speedInMps / 0.514444
                : speedInMps; // Target is mps
  }
}
