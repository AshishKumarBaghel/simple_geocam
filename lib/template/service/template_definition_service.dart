import 'package:simple_geocam/template/template_preference_service.dart';
import 'package:simple_geocam/template/transport/template_address_transport.dart';
import 'package:simple_geocam/template/transport/template_map_transport.dart';
import 'package:simple_geocam/template/transport/template_transport.dart';
import 'package:simple_geocam/template/transport/template_weather_transport.dart';
import 'package:simple_geocam/template/transport/value/altitude_type.dart';
import 'package:simple_geocam/template/transport/value/date_time_format.dart';
import 'package:simple_geocam/template/transport/value/lat_long_type.dart';
import 'package:simple_geocam/template/transport/value/map_position.dart';
import 'package:simple_geocam/template/transport/value/temperature_type.dart';

import '../transport/template.dart';
import '../transport/value/map_type.dart';
import '../transport/value/wind_type.dart';

class TemplateDefinitionService {
  final TemplatePreferenceService _templatePreferenceService = TemplatePreferenceService();

  TemplateTransport getUserSavedTemplate() {
    final String templateKey = _templatePreferenceService.fetchTemplate();
    return Template.getTransportByTitle(templateKey);
  }

  TemplateTransport getExtremeTemplate() {
    final TemplateMapTransport templateMap = TemplateMapTransport(
      hasMapImage: true,
      mapType: MapType.satellite,
      mapPosition: MapPosition.left,
      scale: 15,
      appStamp: true,
    );

    final TemplateAddressTransport templateAddress = TemplateAddressTransport(
      hasAddressTitle: true,
      hasAddress: true,
      hasLatAndLong: true,
      latLongType: LatLongType.decDegs,
      hasDateTime: true,
      dateTimeFormat: DateTimeFormat.shortDateTime12Hour,
    );
    final TemplateWeatherTransport templateWeather = TemplateWeatherTransport(
      hasTemperature: true,
      temperatureType: TemperatureType.celsius,
      hasWind: true,
      windType: WindType.kmph,
      hasCompass: true,
      hasHumidity: true,
      hasAltitude: true,
      altitudeType: AltitudeType.feet,
      hasMagneticField: true,
    );
    return TemplateTransport(
      templateMap: templateMap,
      templateAddress: templateAddress,
      templateWeather: templateWeather,
    );
  }

  TemplateTransport getClassicTemplate() {
    final TemplateMapTransport templateMap = TemplateMapTransport(
      hasMapImage: true,
      mapType: MapType.satellite,
      mapPosition: MapPosition.left,
      scale: 15,
      appStamp: true,
    );
    final TemplateAddressTransport templateAddress = TemplateAddressTransport(
        hasAddressTitle: true,
        hasAddress: true,
        hasLatAndLong: true,
        latLongType: LatLongType.decimal,
        hasDateTime: true,
        dateTimeFormat: DateTimeFormat.fullDate);
    final TemplateWeatherTransport templateWeather = TemplateWeatherTransport(
      hasTemperature: true,
      temperatureType: TemperatureType.celsius,
      hasWind: false,
      hasCompass: true,
      hasHumidity: true,
      hasAltitude: false,
      hasMagneticField: false,
    );
    return TemplateTransport(
      templateMap: templateMap,
      templateAddress: templateAddress,
      templateWeather: templateWeather,
    );
  }

  TemplateTransport getAdvanceTemplate() {
    final TemplateMapTransport templateMap = TemplateMapTransport(
      hasMapImage: true,
      mapType: MapType.satellite,
      mapPosition: MapPosition.left,
      scale: 15,
      appStamp: true,
    );

    final TemplateAddressTransport templateAddress = TemplateAddressTransport(
      hasAddressTitle: true,
      hasAddress: true,
      hasLatAndLong: false,
      hasDateTime: true,
      dateTimeFormat: DateTimeFormat.fullDateTime12Hour,
    );
    final TemplateWeatherTransport templateWeather = TemplateWeatherTransport(
      hasTemperature: false,
      hasWind: true,
      windType: WindType.kmph,
      hasCompass: false,
      hasHumidity: false,
      hasAltitude: true,
      altitudeType: AltitudeType.feet,
      hasMagneticField: false,
    );
    return TemplateTransport(
      templateMap: templateMap,
      templateAddress: templateAddress,
      templateWeather: templateWeather,
    );
  }

  TemplateTransport getHardTemplate() {
    final TemplateMapTransport templateMap = TemplateMapTransport(
      hasMapImage: true,
      mapType: MapType.satellite,
      mapPosition: MapPosition.left,
      scale: 15,
      appStamp: true,
    );

    final TemplateAddressTransport templateAddress = TemplateAddressTransport(
      hasAddressTitle: true,
      hasAddress: true,
      hasLatAndLong: true,
      latLongType: LatLongType.decDegsMicro,
      hasDateTime: true,
      dateTimeFormat: DateTimeFormat.usDateFormat,
    );
    final TemplateWeatherTransport templateWeather = TemplateWeatherTransport(
      hasTemperature: true,
      temperatureType: TemperatureType.fahrenheit,
      hasWind: true,
      windType: WindType.mps,
      hasCompass: true,
      hasHumidity: true,
      hasAltitude: true,
      altitudeType: AltitudeType.feet,
      hasMagneticField: false,
    );
    return TemplateTransport(
      templateMap: templateMap,
      templateAddress: templateAddress,
      templateWeather: templateWeather,
    );
  }

  TemplateTransport getSimpleTemplate() {
    final TemplateMapTransport templateMap = TemplateMapTransport(
      hasMapImage: false,
      mapType: MapType.satellite,
      mapPosition: MapPosition.left,
      scale: 15,
      appStamp: false,
    );

    final TemplateAddressTransport templateAddress = TemplateAddressTransport(
        hasAddressTitle: true,
        hasAddress: true,
        hasLatAndLong: true,
        latLongType: LatLongType.decDegs,
        hasDateTime: true,
        dateTimeFormat: DateTimeFormat.weekdayWithLongDateTime12);
    final TemplateWeatherTransport templateWeather = TemplateWeatherTransport(
      hasTemperature: false,
      hasWind: false,
      hasCompass: false,
      hasHumidity: false,
      hasAltitude: false,
      hasMagneticField: false,
    );
    return TemplateTransport(
      templateMap: templateMap,
      templateAddress: templateAddress,
      templateWeather: templateWeather,
    );
  }

  TemplateTransport getUserTemplate01(){
    //TODO: implement with proper logic
    return getSimpleTemplate();
  }

  TemplateTransport getUserTemplate02(){
    //TODO: implement with proper logic
    return getAdvanceTemplate();
  }

}
