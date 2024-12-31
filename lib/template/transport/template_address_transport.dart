import 'package:simple_geocam/template/transport/value/date_time_format.dart';
import 'package:simple_geocam/template/transport/value/lat_long_type.dart';

class TemplateAddressTransport {
  final bool hasAddressTitle;
  final bool hasAddress;
  final bool hasLatAndLong;
  LatLongType latLongType;
  final bool hasDateTime;
  final DateTimeFormat dateTimeFormat;

  TemplateAddressTransport({
    required this.hasAddressTitle,
    required this.hasAddress,
    required this.hasLatAndLong,
    required this.hasDateTime,
    required this.dateTimeFormat,
    this.latLongType = LatLongType.decDegs,
  });

  // Factory constructor to create an instance from JSON
  factory TemplateAddressTransport.fromJson(Map<String, dynamic> json) {
    return TemplateAddressTransport(
      hasAddressTitle: json['hasAddressTitle'] as bool,
      hasAddress: json['hasAddress'] as bool,
      hasLatAndLong: json['hasLatAndLong'] as bool,
      latLongType: json['latLongType'] as LatLongType,
      hasDateTime: json['hasDateTime'] as bool,
      dateTimeFormat: json['dateTimeFormat'] as DateTimeFormat,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'hasAddressTitle': hasAddressTitle,
      'hasAddress': hasAddress,
      'hasLatAndLong': hasLatAndLong,
      'latLongType': latLongType,
      'hasDateTime': hasDateTime,
      'dateTimeFormat': dateTimeFormat,
    };
  }
}
