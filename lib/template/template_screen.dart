import 'package:flutter/material.dart';
import 'package:simple_geocam/service/geo_service.dart';
import 'package:simple_geocam/template/service/template_definition_service.dart';
import 'package:simple_geocam/template/template_preference_service.dart';
import 'package:simple_geocam/template/transport/template.dart';
import 'package:simple_geocam/template/transport/template_tile.dart';
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
  final TextStyle titleLargeSize = const TextStyle(fontSize: 22, decoration: TextDecoration.underline);
  final TextStyle titleMediumSize = const TextStyle(fontSize: 16);
  final TemplatePreferenceService templatePreferenceService = TemplatePreferenceService();
  late List<TemplateTile> templateTiles;

  @override
  void initState() {
    super.initState();
    _initTemplate();
  }

  void _initTemplate() {
    GeoCamTransport geoCamTransport = geoService.fetchGeoCamDetails();
    final String template = templatePreferenceService.fetchTemplate();
    templateTiles = [
      TemplateTile(
        title: 'User Templates',
        titleStyle: titleLargeSize,
      ),
      TemplateTile(
        title: 'Template 01',
        geoLocationDetail: geoLocationDetail(geoCamTransport, Template.getTransportByTitle('Template 01')),
        titleStyle: titleMediumSize,
        isQuickTemplate: false,
        isChecked: template == 'Template 01'.toLowerCase(),
      ),
      TemplateTile(
        title: 'Template 02',
        geoLocationDetail: geoLocationDetail(geoCamTransport, Template.getTransportByTitle('Template 02')),
        titleStyle: titleMediumSize,
        isQuickTemplate: false,
        isChecked: template == 'Template 02'.toLowerCase(),
      ),
      TemplateTile(
        title: 'Quick Templates',
        titleStyle: titleLargeSize,
      ),
      TemplateTile(
        title: 'Extreme',
        geoLocationDetail: geoLocationDetail(geoCamTransport, Template.getTransportByTitle('Extreme')),
        titleStyle: titleMediumSize,
        isChecked: template == 'Extreme'.toLowerCase(),
      ),
      TemplateTile(
        title: 'Classic',
        geoLocationDetail: geoLocationDetail(geoCamTransport, Template.getTransportByTitle('Classic')),
        titleStyle: titleMediumSize,
        isChecked: template == 'Classic'.toLowerCase(),
      ),
      TemplateTile(
        title: 'Advance',
        geoLocationDetail: geoLocationDetail(geoCamTransport, templateDefinitionService.getAdvanceTemplate()),
        titleStyle: titleMediumSize,
        isChecked: template == 'Advance'.toLowerCase(),
      ),
      TemplateTile(
        title: 'Hard',
        geoLocationDetail: geoLocationDetail(geoCamTransport, Template.getTransportByTitle('Hard')),
        titleStyle: titleMediumSize,
        isChecked: template == 'Hard'.toLowerCase(),
      ),
      TemplateTile(
        title: 'Simple',
        geoLocationDetail: geoLocationDetail(geoCamTransport, Template.getTransportByTitle('simple')),
        titleStyle: titleMediumSize,
        isChecked: template == 'Simple'.toLowerCase(),
      ),
    ];
  }

  GeoLocationDetail geoLocationDetail(GeoCamTransport geoCamTransport, TemplateTransport templateTransport) {
    return GeoLocationDetail(geoCamTransport: geoCamTransport, templateTransport: templateTransport);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Template')),
      body: ListView.builder(
        padding: const EdgeInsets.all(5.0),
        itemCount: templateTiles.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (templateTiles[index].titleStyle == titleLargeSize) Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    templateTiles[index].title,
                    style: templateTiles[index].titleStyle,
                  ),
                  Row(children: [
                    if (!templateTiles[index].isQuickTemplate) IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                    if (templateTiles[index].geoLocationDetail != null)
                      Checkbox(
                        value: templateTiles[index].isChecked,
                        onChanged: (bool? value) {
                          if (value != true) {
                            return;
                          }
                          for (TemplateTile templateTile in templateTiles) {
                            templateTile.isChecked = false;
                          }
                          setState(() {
                            templatePreferenceService.saveTemplate(templateKey: templateTiles[index].title);
                            templateTiles[index].isChecked = value ?? false;
                          });
                        },
                      ),
                  ]),
                ],
              ),
              if (templateTiles[index].geoLocationDetail != null) templateTiles[index].geoLocationDetail!,
            ],
          );
        },
      ),
    );
  }
}
