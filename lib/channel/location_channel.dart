//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

part of backdrop_geo;

class _LocationChannel {
  static const MethodChannel _channel =
      const MethodChannel('backdrop_geo/location');

  static const EventChannel _updatesChannel =
      const EventChannel('backdrop_geo/locationUpdates');

  static const String _loggingTag = 'location result';

  final Stream<LocationOutput> _updatesStream =
      _updatesChannel.receiveBroadcastStream().map((data) {
    _log(data, tag: _loggingTag);
    return Backdecodec.decodeLocationOutput(data);
  });

  final List<_LocationUpdatesSubscription> _updatesSubscriptions = [];

  Future<BackdropResult> isLocationOperational(
      LocationAccess permission) async {
    final response = await _invokeChannelMethod(
      _loggingTag,
      _channel,
      'isLocationOperational',
      Backdecodec.encodeLocationPermission(permission),
    );
    return Backdecodec.decodeResult(response);
  }

  Future<BackdropResult> requestLocationAccess(
      _PermissionRequest request) async {
    final response = await _invokeChannelMethod(
      _loggingTag,
      _channel,
      'requestLocationAccess',
      Backdecodec.encodePermissionRequest(request),
    );
    return Backdecodec.decodeResult(response);
  }

  Future<BackdropResult> enableLocationServices() async {
    final response = await _invokeChannelMethod(
        _loggingTag, _channel, 'enableLocationServices', '');
    return Backdecodec.decodeResult(response);
  }

  Future<LocationOutput> lastKnownLocation(
      LocationAccess permission) async {
    final response = await _invokeChannelMethod(
      _loggingTag,
      _channel,
      'lastKnownLocation',
      Backdecodec.encodeLocationPermission(permission),
    );
    return Backdecodec.decodeLocationOutput(response);
  }

  // Creates a new subscription to the channel stream and notifies
  // the platform about the desired params (accuracy, frequency, strategy) so the platform
  // can start the location request if it's the first subscription or update ongoing request with new params if needed
  Stream<LocationOutput> locationUpdates(_LocationUpdatesRequest request) {
    // The stream that will be returned for the current updates request
    StreamController<LocationOutput> controller;
    _LocationUpdatesSubscription subscription;

    final StreamSubscription<LocationOutput> updatesSubscription =
        _updatesStream.listen((LocationOutput result) {
      // Forward channel stream location result to subscription
      controller.add(result);

      // [_LocationUpdateStrategy.current] and [_LocationUpdateStrategy.single] only get a single result, then closes
      if (request.strategy != _LocationUpdateStrategy.continuous) {
        subscription.subscription.cancel();
        _updatesSubscriptions.remove(subscription);
        controller.close();
      }
    });

    updatesSubscription.onDone(() {
      _updatesSubscriptions.remove(subscription);
    });

    // Uniquely identify each request, in order to be able to manipulate each request of platform side
    request.id = (_updatesSubscriptions.isNotEmpty
            ? _updatesSubscriptions.map((it) => it.requestId).reduce(math.max)
            : 0) +
        1;

    subscription = new _LocationUpdatesSubscription(
      request.id,
      updatesSubscription,
    );
    _updatesSubscriptions.add(subscription);

    controller = new StreamController<LocationOutput>.broadcast(
      onListen: () {
        _log('add location updates [id=${subscription.requestId}]');
        _invokeChannelMethod(
          _loggingTag,
          _channel,
          'addLocationUpdatesRequest',
          Backdecodec.encodeLocationUpdatesRequest(request),
        );
      },
      onCancel: () {
        _log('remove location updates [id=${subscription.requestId}]');
        subscription.subscription.cancel();
        _updatesSubscriptions.remove(subscription);

        _invokeChannelMethod(
          _loggingTag,
          _channel,
          'removeLocationUpdatesRequest',
          subscription.requestId,
        );
      },
    );

    return controller.stream;
  }
}

class _LocationUpdatesSubscription {
  _LocationUpdatesSubscription(this.requestId, this.subscription);

  final int requestId;
  final StreamSubscription<LocationOutput> subscription;
}
