//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

part of backdrop_geo;
class BackdropResult {
  BackdropResult._(
    this.isSuccessful,
    this.error,
  ) {
    assert(isSuccessful != null);
    assert(isSuccessful || error != null);
  }

  final bool isSuccessful;
  final BackdropResultErr error;

  String dataToString() {
    return "without additional data";
  }

  @override
  String toString() {
    if (isSuccessful) {
      return '{success: ${dataToString()} }';
    } else {
      return '{failure: $error }';
    }
  }
}

class BackdropResultErr {
  BackdropResultErr._(
    this.type,
    this.message,
    this.additionalInfo,
  );

  final BackdropResultErrType type;
  final String message;
  final dynamic additionalInfo;

  @override
  String toString() {
    switch (type) {
      case BackdropResultErrType.locationNotFound:
        return 'location not found';
      case BackdropResultErrType.permissionNotGranted:
        return 'permission not granted';
      case BackdropResultErrType.permissionDenied:
        return 'permission denied';
      case BackdropResultErrType.serviceDisabled:
        return 'service disabled';
      case BackdropResultErrType.playServicesUnavailable:
        return 'play services -> $additionalInfo';
      default:
        assert(false);
        return null;
    }
  }
}

enum BackdropResultErrType {
  runtime,
  locationNotFound,
  permissionNotGranted,
  permissionDenied,
  serviceDisabled,
  playServicesUnavailable,
}

BackdropResultErrType _mapResultErrTypeJson(String jsonValue) {
  switch (jsonValue) {
    case 'runtime':
      return BackdropResultErrType.runtime;
    case 'locationNotFound':
      return BackdropResultErrType.locationNotFound;
    case 'permissionNotGranted':
      return BackdropResultErrType.permissionNotGranted;
    case 'permissionDenied':
      return BackdropResultErrType.permissionDenied;
    case 'serviceDisabled':
      return BackdropResultErrType.serviceDisabled;
    case 'playServicesUnavailable':
      return BackdropResultErrType.playServicesUnavailable;
    default:
      assert(
          false, 'cannot parse json to BackdropResultErrType: $jsonValue');
      return null;
  }
}
