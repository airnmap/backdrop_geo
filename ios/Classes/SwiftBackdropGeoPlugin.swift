import Flutter
import UIKit
import CoreLocation

public class SwiftBackdropGeoPlugin: NSObject, FlutterPlugin , UIApplicationDelegate {

 private let locationClient = LocationClient()
  private let handler: Handler

  override init() {
    self.handler = Handler(locationClient: locationClient)
    super.init()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "backdrop_geo", binaryMessenger: registrar.messenger())
    let methodChannel = FlutterMethodChannel(name: "backdrop_geo", binaryMessenger: registrar.messenger())

    let instance = SwiftBackdropGeoPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)
    eventChannel.setStreamHandler(instance.handler.locationUpdatesHandler)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    handler.handleMethodCall(call, result: result)
  }

  public func applicationDidBecomeActive(_ application: UIApplication) {
      locationClient.resume()
  }

  public func applicationWillResignActive(_ application: UIApplication) {
      locationClient.pause()
  }


}
