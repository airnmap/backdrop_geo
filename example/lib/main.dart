//  Copyright (c) 2018 Loup Inc.
//  Licensed under Apache License v2.0

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'tab_location.dart';
import 'tab_track.dart';
import 'tab_settings.dart';
import 'package:backdrop_geo/backdrop_geo.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  MyApp() {
    BackdropGeo.loggingEnabled = true;
  }

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
         // brightness: Brightness.dark,
          primaryColor: Color(0xff202942),
          accentColor: Color(0xff0069d9),
          fontFamily: 'Georgia',
          backgroundColor: Colors.grey,
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Georgia'),
          ),
        ),
      home: new CupertinoTabScaffold(
        tabBar: new CupertinoTabBar(
          backgroundColor: Color(0xff202942),
        items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
              title: new Text('Current',style: TextStyle(color: Colors.white,),),
             // backgroundColor: Colors.white,
              icon: new Icon(Icons.location_on,color: Color(0xff0069d9),),
            ),
            new BottomNavigationBarItem(
              title: new Text('Track',style: TextStyle(color: Colors.white,),),
              icon: new Icon(Icons.location_searching,color: Color(0xff0069d9),),
            ),
            new BottomNavigationBarItem(
              title: new Text('Services',style: TextStyle(color: Colors.white,),),
              icon: new Icon(Icons.location_off,color: Color(0xff0069d9),),
            ),
            new BottomNavigationBarItem(
              title: new Text('Settings',style: TextStyle(color: Colors.white,),),
              icon: new Icon(Icons.settings_input_antenna,color: Color(0xff0069d9),),
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return new CupertinoTabView(
            builder: (BuildContext context) {
              switch (index) {
                case 0:
                  return new TabLocation();
                case 1:
                  return new TabTrack();
                case 3:
                  return new TabSettings();
                default:
                  return new Container(
                    color: Colors.white,
                    child: new Center(
                      child: new FlatButton(
                        color: Color(0xff202942),
                        child: Text(
                          "Allow location",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: enableLocationServices,
                      ),
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }

  enableLocationServices() async {
    BackdropGeo.enableLocationServices().then((result) {
      // Request location
    }).catchError((e) {
      // Location Services Enablind Cancelled
    });
  }
}
