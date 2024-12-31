import 'package:simple_geocam/template/transport/value/map_position.dart';
import 'package:simple_geocam/template/transport/value/map_type.dart';

class TemplateMapTransport {
  final bool hasMapImage;
  final MapType mapType;
  final MapPosition mapPosition;
  final int scale;
  final bool appStamp;

  TemplateMapTransport({
    required this.hasMapImage,
    required this.mapType,
    required this.mapPosition,
    required this.scale,
    required this.appStamp,
  });

  // Factory constructor to create an instance from JSON
  factory TemplateMapTransport.fromJson(Map<String, dynamic> json) {
    return TemplateMapTransport(
      hasMapImage: json['hasMapImage'] as bool,
      mapType: json['mapType'] as MapType,
      mapPosition: json['mapPosition'] as MapPosition,
      scale: json['scale'] as int,
      appStamp: json['appStamp'] as bool,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'hasMapImage': hasMapImage,
      'mapType': mapType,
      'mapPosition': mapPosition,
      'scale': scale,
      'appStamp': appStamp,
    };
  }
}
