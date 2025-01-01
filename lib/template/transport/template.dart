import 'package:simple_geocam/template/service/template_definition_service.dart';
import 'package:simple_geocam/template/transport/template_transport.dart';

enum Template {
  template01,
  template02,
  classic,
  simple,
  extreme,
  advance,
  hard;

  // Add a method to retrieve the title for each template
  String get templateTitle {
    switch (this) {
      case Template.template01:
        return 'Template 01';
      case Template.template02:
        return 'Template 02';
      case Template.classic:
        return 'Classic';
      case Template.simple:
        return 'Simple';
      case Template.extreme:
        return 'Extreme';
      case Template.advance:
        return 'Advance';
      case Template.hard:
        return 'Hard';
    }
  }

  // Static service instance for shared behavior
  static final TemplateDefinitionService _templateService = TemplateDefinitionService();

  // Add a method to fetch transport
  TemplateTransport get templateTransport {
    switch (this) {
      case Template.classic:
        return _templateService.getClassicTemplate();
      case Template.simple:
        return _templateService.getSimpleTemplate();
      case Template.hard:
        return _templateService.getHardTemplate();
      case Template.advance:
        return _templateService.getAdvanceTemplate();
      case Template.extreme:
        return _templateService.getExtremeTemplate();
      case Template.template01:
        return _templateService.getUserTemplate01();
      case Template.template02:
        return _templateService.getUserTemplate02();
    }
  }

  // Static method to get TemplateTransport by title
  static TemplateTransport getTransportByTitle(String title) {
    for (var template in Template.values) {
      if (template.templateTitle.toLowerCase() == title.toLowerCase()) {
        return template.templateTransport;
      }
    }
    // Return null if no matching title is found
    throw UnimplementedError('Transport for $title is not implemented.');
  }
}
