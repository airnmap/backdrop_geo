//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

part of backdrop_geo;

/// Necessarily permission to work with location service on Android and iOS.
///
/// See also:
///
///  * [LocationRequestAndroid], to which this defers for Android.
///  * [LocationPermissionIOS], to which this defers for iOS.
class LocationAccess {
  const LocationAccess({
    this.android = LocationRequestAndroid.fine,
    this.ios = LocationPermissionIOS.whenInUse,
  });

  final LocationRequestAndroid android;
  final LocationPermissionIOS ios;
}
