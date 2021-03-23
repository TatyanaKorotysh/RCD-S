//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<native_device_orientation/NativeDeviceOrientationPlugin.h>)
#import <native_device_orientation/NativeDeviceOrientationPlugin.h>
#else
@import native_device_orientation;
#endif

#if __has_include(<qr_mobile_vision/QrMobileVisionPlugin.h>)
#import <qr_mobile_vision/QrMobileVisionPlugin.h>
#else
@import qr_mobile_vision;
#endif

#if __has_include(<wifi/WifiPlugin.h>)
#import <wifi/WifiPlugin.h>
#else
@import wifi;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [NativeDeviceOrientationPlugin registerWithRegistrar:[registry registrarForPlugin:@"NativeDeviceOrientationPlugin"]];
  [QrMobileVisionPlugin registerWithRegistrar:[registry registrarForPlugin:@"QrMobileVisionPlugin"]];
  [WifiPlugin registerWithRegistrar:[registry registrarForPlugin:@"WifiPlugin"]];
}

@end
