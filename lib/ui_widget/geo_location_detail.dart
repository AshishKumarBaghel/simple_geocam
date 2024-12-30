import 'package:flutter/material.dart';
import 'package:simple_geocam/service/geo_service.dart';
import 'package:simple_geocam/transport/geo_cam_address_transport.dart';
import 'package:simple_geocam/transport/geo_cam_weather_transport.dart';

import '../transport/geo_cam_transport.dart';

class GeoLocationDetail extends StatelessWidget {
  final GeoCamTransport geoCamTransport;
  final GlobalKey geoCamContainerKey;
  final GeoService geoService = GeoService();
  final double iconSize = 20;

  GeoLocationDetail({super.key, required this.geoCamContainerKey, required this.geoCamTransport});

  @override
  Widget build(BuildContext context) {
    final GeoCamAddressTransport geoCamAddress = geoCamTransport.address;
    final GeoCamWeatherTransport geoCamWeather = geoCamTransport.weather;
    Color backgroundColor = Colors.black.withValues(alpha: 0.5);
    return RepaintBoundary(
      key: geoCamContainerKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
        child: Column(
          children: [
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
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12), bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Image from assets
                      // Stretch the image to fit the container
                      SizedBox(
                        width: 90, // Adjust width
                        height: 145, // Adjust height
                        child: Image.asset(
                          'assets/map/map_location.jpg', // Replace with your asset path
                          fit: BoxFit.fill, // Stretches the image
                        ),
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              geoCamAddress.addressTitle,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              geoCamAddress.address,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lat ${geoCamAddress.lat}, Long ${geoCamAddress.lon}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(geoService.format.format(geoCamAddress.dateTime),
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_cloudy.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(geoCamWeather.temperature, style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_wind.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(geoCamWeather.wind, style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_compass.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(geoCamWeather.compass, style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_humidity.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(geoCamWeather.humidity, style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_mountain.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(geoCamWeather.altitude, style: const TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/icon/icon_magnet.png',
                                          width: iconSize, // adjust size as needed
                                          height: iconSize,
                                        ),
                                        Text(geoCamWeather.magneticField, style: const TextStyle(color: Colors.white)),
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
      ),
    );
  }
}
