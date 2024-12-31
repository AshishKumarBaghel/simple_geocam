import 'dart:math';

enum LatLongType {
  decimal("Decimal"), // Decimal Degrees
  decDegs("Dec Degs"), // Degrees with Decimal
  decDegsMicro("Dec Degs Micro"), // Degrees with Micro Precision
  decMins("Dec Mins"), // Decimal Minutes
  degMinsSecs("Deg Mins Secs"), // Degrees, Minutes, Seconds
  decMinsSecs("Dec Mins Secs"), // Decimal Minutes, Seconds
  utm("UTM"); // Universal Transverse Mercator

  final String displayName;

  const LatLongType(this.displayName);

  /// Formats latitude and longitude based on the type
  String format(double latitude, double longitude) {
    switch (this) {
      case LatLongType.decimal:
        return "Lat ${latitude.toStringAsFixed(6)} Long ${longitude.toStringAsFixed(6)}";
      case LatLongType.decDegs:
        return "Lat ${_toDegrees(latitude)}° Long ${_toDegrees(longitude)}°";
      case LatLongType.decDegsMicro:
        return "Lat ${_toDegrees(latitude)} N Long ${_toDegrees(longitude)} E";
      case LatLongType.decMins:
        return "Lat ${_toDecimalMinutes(latitude)} Long ${_toDecimalMinutes(longitude)}";
      case LatLongType.degMinsSecs:
        return "Lat N ${_toDegreesMinutesSeconds(latitude)} Long E ${_toDegreesMinutesSeconds(longitude)}";
      case LatLongType.decMinsSecs:
        return "Lat ${_toDecimalMinutesSeconds(latitude)} N Long ${_toDecimalMinutesSeconds(longitude)} E";
      case LatLongType.utm:
        return _toUTM(latitude, longitude); // Placeholder for UTM conversion logic
    }
  }

  /// Converts a decimal value to degrees
  String _toDegrees(double value) => value.toStringAsFixed(6);

  /// Converts a decimal value to decimal minutes
  String _toDecimalMinutes(double value) {
    int degrees = value.truncate();
    double minutes = (value.abs() - degrees.abs()) * 60;
    return "${degrees.toStringAsFixed(0)}.${minutes.toStringAsFixed(6)}";
  }

  /// Converts a decimal value to degrees, minutes, and seconds
  String _toDegreesMinutesSeconds(double value) {
    int degrees = value.truncate();
    double remaining = (value.abs() - degrees.abs()) * 60;
    int minutes = remaining.truncate();
    double seconds = (remaining - minutes) * 60;
    return "$degrees° $minutes' ${seconds.toStringAsFixed(6)}\"";
  }

  /// Converts a decimal value to decimal minutes and seconds
  String _toDecimalMinutesSeconds(double value) {
    double minutes = value * 60;
    double seconds = (minutes - minutes.truncate()) * 60;
    return "${minutes.truncate()}.${seconds.toStringAsFixed(6)}";
  }

  String _toUTM(double latitude, double longitude) {
    // Constants for UTM calculation
    const double a = 6378137.0; // WGS84 major axis
    const double f = 1 / 298.257223563; // WGS84 flattening
    const double k0 = 0.9996; // Scale factor

    final double e = sqrt(f * (2 - f)); // Eccentricity
    final double e1sq = e * e / (1 - e * e);

    // Zone calculation
    int zoneNumber = ((longitude + 180) / 6).floor() + 1;

    // Central meridian of the zone
    double lonOrigin = (zoneNumber - 1) * 6 - 180 + 3;

    double latRad = latitude * pi / 180.0;
    double lonRad = longitude * pi / 180.0;
    double lonOriginRad = lonOrigin * pi / 180.0;

    double n = a / sqrt(1 - e * e * sin(latRad) * sin(latRad));
    double t = tan(latRad) * tan(latRad);
    double c = e1sq * cos(latRad) * cos(latRad);
    double aL = cos(latRad) * (lonRad - lonOriginRad);

    // Easting and Northing
    double m = a *
        ((1 - e * e / 4 - 3 * e * e * e * e / 64 - 5 * e * e * e * e * e * e / 256) * latRad -
            (3 * e * e / 8 + 3 * e * e * e * e / 32 + 45 * e * e * e * e * e * e / 1024) * sin(2 * latRad) +
            (15 * e * e * e * e / 256 + 45 * e * e * e * e * e * e / 1024) * sin(4 * latRad) -
            (35 * e * e * e * e * e * e / 3072) * sin(6 * latRad));

    double utmEasting =
        (k0 * n * (aL + (1 - t + c) * pow(aL, 3) / 6 + (5 - 18 * t + t * t + 72 * c - 58 * e1sq) * pow(aL, 5) / 120) + 500000.0);

    double utmNorthing = (k0 *
        (m +
            n *
                tan(latRad) *
                (pow(aL, 2) / 2 +
                    (5 - t + 9 * c + 4 * c * c) * pow(aL, 4) / 24 +
                    (61 - 58 * t + t * t + 600 * c - 330 * e1sq) * pow(aL, 6) / 720)));

    if (latitude < 0) {
      utmNorthing += 10000000.0; // Adjust for southern hemisphere
    }

    return "Zone $zoneNumber, Easting ${utmEasting.toStringAsFixed(4)}, Northing ${utmNorthing.toStringAsFixed(4)}";
  }
}
