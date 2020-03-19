import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backdrop_geo/backdrop_geo.dart';

void main() {
  const MethodChannel channel = MethodChannel('backdrop_geo');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await BackdropGeo.platformVersion, '42');
  });
}
