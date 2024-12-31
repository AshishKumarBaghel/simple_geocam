import 'package:intl/intl.dart';
import 'package:simple_geocam/transport/geo_cam_address_transport.dart';
import 'package:simple_geocam/transport/geo_cam_transport.dart';

import '../transport/geo_cam_weather_transport.dart';

class GeoService {
  // Specify the format:
  // - MM/dd/yyyy  -> 12/26/2024
  // - hh:mm       -> 04:05   (12-hour format)
  // - a           -> PM
  // - 'GMT'       -> literal text "GMT"
  // - xxx         -> +05:30 (ISO 8601 extended offset with a colon)
  final format = DateFormat("MM/dd/yyyy hh:mm a 'GMT' +05:30");

  GeoCamTransport fetchGeoCamDetails() {
    GeoCamAddressTransport geoCamAddressTransport = GeoCamAddressTransport(
      addressTitle: 'Ujjain Madhya Pradesh, India',
      address: 'Mahananda Nagar, Ujjain - 456010, Madhya Pradesh, India',
      lat: 23.1500,
      long: 75.802633,
      dateTime: getCurrentDateTime(),
    );

    GeoCamWeatherTransport geoCamWeatherTransport = GeoCamWeatherTransport(
      temperature: 76,
      wind: 8.0,
      altitude: 1636,
      compass: '225°',
      humidity: '77',
      magneticField: '50',
    );

    return GeoCamTransport(address: geoCamAddressTransport, weather: geoCamWeatherTransport);
  }

  DateTime getCurrentDateTime() {
    DateTime utcDateTime = DateTime.now().toUtc();
    return utcDateTime;
  }
}
