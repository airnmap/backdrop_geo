//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

part of backdrop_geo;

enum BackdropGeoServices {
  missing,
  updating,
  versionUpdateRequired,
  disabled,
  invalid,
}

BackdropGeoServices _mapPlayServicesJson(String jsonValue) {
  switch (jsonValue) {
    case 'missing':
      return BackdropGeoServices.missing;
    case 'updating':
      return BackdropGeoServices.updating;
    case 'versionUpdateRequired':
      return BackdropGeoServices.versionUpdateRequired;
    case 'disabled':
      return BackdropGeoServices.disabled;
    case 'invalid':
      return BackdropGeoServices.invalid;
    default:
      assert(false,
          'cannot parse json to BackdropGeoServices: $jsonValue');
      return null;
  }
}
