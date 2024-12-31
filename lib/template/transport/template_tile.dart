import 'package:flutter/material.dart';

import '../../ui_widget/geo_location_detail.dart';

class TemplateTile {
  final String title;
  TextStyle? titleStyle;
  GeoLocationDetail? geoLocationDetail;
  bool isChecked;
  bool isQuickTemplate;

  TemplateTile({
    required this.title,
    this.titleStyle,
    this.geoLocationDetail,
    this.isChecked = false,
    this.isQuickTemplate = true,
  });

  // Factory constructor to create an instance from JSON
  factory TemplateTile.fromJson(Map<String, dynamic> json) {
    return TemplateTile(
      title: json['title'] as String,
      titleStyle: json['titleStyle'] as TextStyle?,
      geoLocationDetail: json['geoLocationDetail'] as GeoLocationDetail,
      isChecked: json['isChecked'] as bool,
      isQuickTemplate: json['isQuickTemplate'] as bool,
    );
  }

  // Optional: Convert an instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'titleStyle': titleStyle,
      'geoLocationDetail': geoLocationDetail,
      'isChecked': isChecked,
      'isQuickTemplate': isQuickTemplate,
    };
  }
}
