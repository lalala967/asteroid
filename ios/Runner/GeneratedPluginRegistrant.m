//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<camera_avfoundation/CameraPlugin.h>)
#import <camera_avfoundation/CameraPlugin.h>
#else
@import camera_avfoundation;
#endif

#if __has_include(<flutter_tts/FlutterTtsPlugin.h>)
#import <flutter_tts/FlutterTtsPlugin.h>
#else
@import flutter_tts;
#endif

#if __has_include(<flutter_vision/FlutterVisionPlugin.h>)
#import <flutter_vision/FlutterVisionPlugin.h>
#else
@import flutter_vision;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CameraPlugin registerWithRegistrar:[registry registrarForPlugin:@"CameraPlugin"]];
  [FlutterTtsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterTtsPlugin"]];
  [FlutterVisionPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterVisionPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
}

@end
