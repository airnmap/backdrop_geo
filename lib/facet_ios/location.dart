
part of backdrop_geo;

enum LocationAccuracyIOS {
  threeKilometers,
  kilometer,
  hundredMeters,
  nearestTenMeters,
  best,
  bestForNavigation
}

class LocationOptionsIOS {
  const LocationOptionsIOS({
    this.showsBackgroundLocationIndicator = false,
    this.activityType = LocationActivityIOS.other,
  });

  final bool showsBackgroundLocationIndicator;
  final LocationActivityIOS activityType;

  Map toJson() => {
        'showsBackgroundLocationIndicator': showsBackgroundLocationIndicator,
        'activityType': Backdecodec.encodeEnum(activityType)
      };

  toMap() => {
        'showsBackgroundLocationIndicator': showsBackgroundLocationIndicator,
        'activityType': activityType.toString().split('.').last
      };
}

enum LocationActivityIOS {
  other,
  automotiveNavigation,
  fitness,
  otherNavigation
}
