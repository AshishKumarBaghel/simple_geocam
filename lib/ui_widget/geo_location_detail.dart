import 'package:flutter/material.dart';
import 'package:simple_geocam/service/geo_service.dart';
import 'package:simple_geocam/template/transport/template_transport.dart';
import 'package:simple_geocam/template/transport/value/altitude_type.dart';
import 'package:simple_geocam/transport/geo_cam_address_transport.dart';
import 'package:simple_geocam/transport/geo_cam_weather_transport.dart';

import '../template/transport/value/temperature_type.dart';
import '../template/transport/value/wind_type.dart';
import '../transport/geo_cam_transport.dart';

class GeoLocationDetail extends StatelessWidget {
  final GeoCamTransport geoCamTransport;
  final GeoService geoService = GeoService();
  final double iconSize = 20;
  final TemplateTransport templateTransport;

  GeoLocationDetail({super.key, required this.geoCamTransport, required this.templateTransport});

  @override
  Widget build(BuildContext context) {
    final GeoCamAddressTransport geoCamAddress = geoCamTransport.address;
    final GeoCamWeatherTransport geoCamWeather = geoCamTransport.weather;
    Color backgroundColor = Colors.black.withValues(alpha: 0.5);
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
      child: Column(
        children: [
          if (templateTransport.templateMap.appStamp)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 20, // Adjust width
                        height: 20, // Adjust height
                        child: Image.asset(
                          'assets/icon/icon_app_camera.png', // Replace with your asset path
                          fit: BoxFit.fill, // Stretches the image
                        ),
                      ),
                      SizedBox(width: 5),
                      Text('Simple Geo Cam', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  topRight: (!templateTransport.templateMap.appStamp) ? const Radius.circular(12) : const Radius.circular(0)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Image from assets
                    // Stretch the image to fit the container
                    if (templateTransport.templateMap.hasMapImage)
                      SizedBox(
                        width: 90, // Adjust width
                        height: 145, // Adjust height
                        child: Image.asset(
                          'assets/map/map_location.jpg', // Replace with your asset path
                          fit: BoxFit.fill, // Stretches the image
                        ),
                      ),
                    if (templateTransport.templateMap.hasMapImage) const SizedBox(width: 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (templateTransport.templateAddress.hasAddressTitle)
                            Text(
                              geoCamAddress.addressTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (templateTransport.templateAddress.hasAddressTitle) const SizedBox(height: 4),
                          if (templateTransport.templateAddress.hasAddress)
                            Text(
                              geoCamAddress.address,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          if (templateTransport.templateAddress.hasAddress) const SizedBox(height: 4),
                          if (templateTransport.templateAddress.hasLatAndLong)
                            Text(
                              templateTransport.templateAddress.latLongType.format(geoCamAddress.lat, geoCamAddress.long),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          if (templateTransport.templateAddress.hasLatAndLong) const SizedBox(height: 4),
                          if (templateTransport.templateAddress.hasDateTime)
                            Text(templateTransport.templateAddress.dateTimeFormat.format(geoCamAddress.dateTime),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (templateTransport.templateWeather.hasTemperature)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_cloudy.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(
                                            templateTransport.templateWeather.temperatureType
                                                .format(geoCamWeather.temperature, to: TemperatureType.celsius),
                                            style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  if (templateTransport.templateWeather.hasWind)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_wind.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(templateTransport.templateWeather.windType.format(geoCamWeather.wind, to: WindType.kmph),
                                            style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (templateTransport.templateWeather.hasCompass)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_compass.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text('${geoCamWeather.compass} SW', style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  if (templateTransport.templateWeather.hasHumidity)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_humidity.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text('${geoCamWeather.humidity}%', style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (templateTransport.templateWeather.hasAltitude)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_mountain.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(
                                            templateTransport.templateWeather.altitudeType
                                                .format(geoCamWeather.altitude, to: AltitudeType.meter),
                                            style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  if (templateTransport.templateWeather.hasMagneticField)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_magnet.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text('${geoCamWeather.magneticField} uT', style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
