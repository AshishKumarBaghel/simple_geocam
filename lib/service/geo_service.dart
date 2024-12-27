import 'package:intl/intl.dart';
import 'package:simple_geocam/transport/geo_cam_transport.dart';

class GeoService {
  // Specify the format:
  // - MM/dd/yyyy  -> 12/26/2024
  // - hh:mm       -> 04:05   (12-hour format)
  // - a           -> PM
  // - 'GMT'       -> literal text "GMT"
  // - xxx         -> +05:30 (ISO 8601 extended offset with a colon)
  final format = DateFormat("MM/dd/yyyy hh:mm a 'GMT' +05:30");

  GeoCamTransport fetchGeoCamDetails() {
    GeoCamTransport geoCamTransport = GeoCamTransport(
      addressTitle: 'Ujjain Madhya Pradesh, India',
      address: 'Mahananda Nagar, Ujjain - 456010, Madhya Pradesh, India',
      lat: '23.1500',
      lon: '75.802633',
      dateTime: DateTime(2024, 12, 26, 18, 41, 22, 09, 9),
      note: 'Captured by Simple Geo Cam',
    );

    return geoCamTransport;
  }
}
