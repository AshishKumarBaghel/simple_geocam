import 'package:flutter/material.dart';
import 'package:simple_geocam/service/geo_service.dart';
import 'package:simple_geocam/template/service/template_definition_service.dart';
import 'package:simple_geocam/template/transport/template_transport.dart';
import 'package:simple_geocam/ui_widget/geo_location_detail.dart';

import '../transport/geo_cam_transport.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  final GeoService geoService = GeoService();
  final TemplateDefinitionService templateDefinitionService = TemplateDefinitionService();

  @override
  Widget build(BuildContext context) {
    GeoCamTransport geoCamTransport = geoService.fetchGeoCamDetails();
    return Scaffold(
      appBar: AppBar(title: const Text('Template')),
      body: ListView(
        padding: const EdgeInsets.all(5.0),
        children: [
          SectionWidget(
            title: 'Extreme',
            geoLocationDetail: GeoLocationDetail(
              geoCamTransport: geoCamTransport,
              templateTransport: templateDefinitionService.getExtremeTemplate(),
            ),
          ),
          SectionWidget(
            title: 'Classic',
            geoLocationDetail: GeoLocationDetail(
              geoCamTransport: geoCamTransport,
              templateTransport: templateDefinitionService.getClassicTemplate(),
            ),
          ),
          SectionWidget(
            title: 'Advance',
            geoLocationDetail: GeoLocationDetail(
              geoCamTransport: geoCamTransport,
              templateTransport: templateDefinitionService.getAdvanceTemplate(),
            ),
          ),
          SectionWidget(
            title: 'Hard',
            geoLocationDetail: GeoLocationDetail(
              geoCamTransport: geoCamTransport,
              templateTransport: templateDefinitionService.getHardTemplate(),
            ),
          ),
          SectionWidget(
            title: 'Simple',
            geoLocationDetail: GeoLocationDetail(
              geoCamTransport: geoCamTransport,
              templateTransport: templateDefinitionService.getSimpleTemplate(),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionWidget extends StatelessWidget {
  final String title;
  final GeoLocationDetail geoLocationDetail;

  const SectionWidget({
    super.key,
    required this.title,
    required this.geoLocationDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        geoLocationDetail,
      ],
    );
  }
}
