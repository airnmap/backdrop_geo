//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

part of backdrop_geo;

class Backdecodec {
  static BackdropResult decodeResult(String data) =>
      _JsonCodec.resultFromJson(json.decode(data));

  static LocationOutput decodeLocationOutput(String data) =>
      _JsonCodec.locationResultFromJson(json.decode(data));

  static String encodeLocationPermission(LocationAccess permission) =>
      Backdecodec.platformSpecific(
        android: Backdecodec.encodeEnum(permission.android),
        ios: Backdecodec.encodeEnum(permission.ios),
      );

  static String encodeLocationUpdatesRequest(_LocationUpdatesRequest request) =>
      json.encode(_JsonCodec.locationUpdatesRequestToJson(request));

  static String encodePermissionRequest(_PermissionRequest request) =>
      json.encode(_JsonCodec.permissionRequestToJson(request));

  // see: https://stackoverflow.com/questions/49611724/dart-how-to-json-decode-0-as-double
  static double parseJsonNumber(dynamic value) {
    return value.runtimeType == int ? (value as int).toDouble() : value;
  }

  static bool parseJsonBoolean(dynamic value) {
    return value.toString() == 'true';
  }

  static String encodeEnum(dynamic value) {
    return value.toString().split('.').last;
  }

  static dynamic platformSpecific({
    @required dynamic android,
    @required dynamic ios,
  }) {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    } else {
      throw new GeolocationException(
          'Unsupported platform: ${Platform.operatingSystem}');
    }
  }

  static Map<String, dynamic> platformSpecificMap({
    @required Map<String, dynamic> android,
    @required Map<String, dynamic> ios,
  }) {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    } else {
      throw new GeolocationException(
          'Unsupported platform: ${Platform.operatingSystem}');
    }
  }
}

class _JsonCodec {
  static BackdropResult resultFromJson(Map<String, dynamic> json) =>
      new BackdropResult._(
        json['isSuccessful'],
        json['error'] != null ? resultErrorFromJson(json['error']) : null,
      );

  static BackdropResultErr resultErrorFromJson(Map<String, dynamic> json) {
    final BackdropResultErrType type =
       _mapResultErrTypeJson(json['type']);

    var additionalInfo;
    switch (type) {
      case BackdropResultErrType.playServicesUnavailable:
        additionalInfo = _mapPlayServicesJson(json['playServices']);
        break;
      default:
        additionalInfo = null;
    }

    final BackdropResultErr error = new BackdropResultErr._(
      type,
      json['message'],
      additionalInfo,
    );

    if (json.containsKey('fatal') && json['fatal']) {
      throw new GeolocationException(error.message);
    }

    return error;
  }

  static LocationOutput locationResultFromJson(Map<String, dynamic> json) =>
      new LocationOutput._(
        json['isSuccessful'],
        json['error'] != null ? resultErrorFromJson(json['error']) : null,
        json['data'] != null
            ? (json['data'] as List<dynamic>)
                .map((it) => locationFromJson(it as Map<String, dynamic>))
                .toList()
            : null,
      );

  static Location locationFromJson(Map<String, dynamic> json) => new Location._(
    Backdecodec.parseJsonNumber(json['latitude']),
    Backdecodec.parseJsonNumber(json['longitude']),
    Backdecodec.parseJsonNumber(json['altitude']),
    Backdecodec.parseJsonBoolean(json['isMocked']),
      );

  static Map<String, dynamic> locationUpdatesRequestToJson(
          _LocationUpdatesRequest request) =>
      {
        'id': request.id,
        'strategy': Backdecodec.encodeEnum(request.strategy),
        'permission': Backdecodec.encodeLocationPermission(request.permission),
        'accuracy': Backdecodec.platformSpecific(
          android: Backdecodec.encodeEnum(request.accuracy.android),
          ios: Backdecodec.encodeEnum(request.accuracy.ios),
        ),
        'displacementFilter': request.displacementFilter,
        'inBackground': request.inBackground,
        'options': Backdecodec.platformSpecific(
          android: request.androidOptions,
          ios: request.iosOptions,
        ),
      };

  static Map<String, dynamic> permissionRequestToJson(
          _PermissionRequest request) =>
      {
        'value': Backdecodec.encodeLocationPermission(request.value),
        'openSettingsIfDenied': request.openSettingsIfDenied,
      };
}
