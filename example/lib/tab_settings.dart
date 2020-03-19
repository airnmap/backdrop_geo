//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:backdrop_geo/backdrop_geo.dart';

class TabSettings extends StatefulWidget {
  @override
  _TabSettingsState createState() => new _TabSettingsState();
}

class _TabSettingsState extends State<TabSettings> {
  BackdropResult _locationOperationalResult;
  BackdropResult _requestPermissionResult;

  _checkLocationOperational() async {
    final BackdropResult result = await BackdropGeo.isLocationOperational();

    if (mounted) {
      setState(() {
        _locationOperationalResult = result;
      });
    }
  }

  _requestPermission() async {
    final BackdropResult result =
        await BackdropGeo.requestLocationAccess(
      permission: const LocationAccess(
        android: LocationRequestAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );

    if (mounted) {
      setState(() {
        _requestPermissionResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Settings'),
      ),
      body: new ListView(
        children: ListTile.divideTiles(context: context, tiles: [
          new _Item(
            title: 'Is location operational',
            successLabel: 'Yes',
            result: _locationOperationalResult,
            onPressed: _checkLocationOperational,
          ),
          new _Item(
            title: 'Request permission',
            successLabel: 'Granted',
            result: _requestPermissionResult,
            onPressed: _requestPermission,
          ),
        ]).toList(),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  _Item({
    @required this.title,
    @required this.successLabel,
    @required this.result,
    @required this.onPressed,
  });

  final String title;
  final String successLabel;
  final BackdropResult result;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    String value;
    String status;
    Color color;

    if (result != null) {
      if (result.isSuccessful) {
        value = successLabel;
        status = 'success';
        color = Colors.green;
      } else {
        switch (result.error.type) {
          case BackdropResultErrType.runtime:
            value = 'Failure: ${result.error.message}';
            break;
          case BackdropResultErrType.locationNotFound:
            value = 'Location not found';
            break;
          case BackdropResultErrType.serviceDisabled:
            value = 'Service disabled';
            break;
          case BackdropResultErrType.permissionNotGranted:
            value = 'Permission not granted';
            break;
          case BackdropResultErrType.permissionDenied:
            value = 'Permission denied';
            break;
          case BackdropResultErrType.playServicesUnavailable:
            value = 'Play services unavailable: ${result.error.additionalInfo}';
            break;
        }

        status = 'failure';
        color = Colors.red;
      }
    } else {
      value = 'Unknown';
      status = 'undefined';
      color = Colors.blueGrey;
    }

    final text = '$title: $value';

    final List<Widget> content = <Widget>[
      Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(
        height: 3,
      ),
      Text(
        'Tap to trigger',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ];

    return new GestureDetector(
      onTap: onPressed,
      child: new Container(
        color: Colors.white,
        child: new SizedBox(
          height: 80,
          child: new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Expanded(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content,
                  ),
                ),
                new Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: new BoxDecoration(
                    color: color,
                    borderRadius: new BorderRadius.circular(6.0),
                  ),
                  child: new Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
