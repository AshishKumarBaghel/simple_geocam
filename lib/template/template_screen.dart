import 'package:flutter/material.dart';
import 'package:simple_geocam/service/geo_service.dart';
import 'package:simple_geocam/template/service/template_definition_service.dart';
import 'package:simple_geocam/template/template_preference_service.dart';
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
    // TODO: implement initState
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
        geoLocationDetail: geoLocationDetail(geoCamTransport, templateDefinitionService.getSimpleTemplate()),
        titleStyle: titleMediumSize,
        isQuickTemplate: false,
        isChecked: template == 'template 01',
      ),
      TemplateTile(
        title: 'Template 02',
        geoLocationDetail: geoLocationDetail(geoCamTransport, templateDefinitionService.getClassicTemplate()),
        titleStyle: titleMediumSize,
        isQuickTemplate: false,
        isChecked: template == 'template 02',
      ),
      TemplateTile(
        title: 'Quick Templates',
        titleStyle: titleLargeSize,
      ),
      TemplateTile(
        title: 'Extreme',
        geoLocationDetail: geoLocationDetail(geoCamTransport, templateDefinitionService.getExtremeTemplate()),
        titleStyle: titleMediumSize,
        isChecked: template == 'extreme',
      ),
      TemplateTile(
        title: 'Classic',
        geoLocationDetail: geoLocationDetail(geoCamTransport, templateDefinitionService.getClassicTemplate()),
        titleStyle: titleMediumSize,
        isChecked: template == 'classic',
      ),
      TemplateTile(
        title: 'Advance',
        geoLocationDetail: geoLocationDetail(geoCamTransport, templateDefinitionService.getAdvanceTemplate()),
        titleStyle: titleMediumSize,
        isChecked: template == 'advance',
      ),
      TemplateTile(
        title: 'Hard',
        geoLocationDetail: geoLocationDetail(geoCamTransport, templateDefinitionService.getHardTemplate()),
        titleStyle: titleMediumSize,
        isChecked: template == 'hard',
      ),
      TemplateTile(
        title: 'Simple',
        geoLocationDetail: geoLocationDetail(geoCamTransport, templateDefinitionService.getSimpleTemplate()),
        titleStyle: titleMediumSize,
        isChecked: template == 'simple',
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

/*ListView(
        padding: const EdgeInsets.all(5.0),
        children: [
          Text(
            'Quick Templates',
            style: Theme.of(context).textTheme.titleLarge,
          ),
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
  }*/
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Checkbox(value: true, onChanged: (value) {}),
          ],
        ),
        geoLocationDetail,
      ],
    );
  }
}
