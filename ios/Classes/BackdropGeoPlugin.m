#import "BackdropGeoPlugin.h"
#if __has_include(<backdrop_geo/backdrop_geo-Swift.h>)
#import <backdrop_geo/backdrop_geo-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "backdrop_geo-Swift.h"
#endif

@implementation BackdropGeoPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBackdropGeoPlugin registerWithRegistrar:registrar];
}
@end
