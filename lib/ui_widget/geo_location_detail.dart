import 'package:flutter/material.dart';
import 'package:simple_geocam/service/geo_service.dart';

import '../transport/geo_cam_transport.dart';

class GeoLocationDetail extends StatelessWidget {
  final GeoCamTransport geoCamTransport;
  final GlobalKey geoCamContainerKey;
  final GeoService geoService = GeoService();

  GeoLocationDetail({super.key, required this.geoCamContainerKey, required this.geoCamTransport});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: geoCamContainerKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Image from assets
                  // Stretch the image to fit the container
                  Container(
                    width: 90, // Adjust width
                    height: 110, // Adjust height
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
                          geoCamTransport.addressTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          geoCamTransport.address,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lat ${geoCamTransport.lat}, Long ${geoCamTransport.lon}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(geoService.format.format(geoCamTransport.dateTime.toLocal()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            )),
                        /*const SizedBox(height: 4),
                        Text(
                          'Note: ${geoCamTransport.note}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ],
              ),
              Row(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
