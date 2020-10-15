//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_sound/Flauto.h>)
#import <flutter_sound/Flauto.h>
#else
@import flutter_sound;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<permission_handler/PermissionHandlerPlugin.h>)
#import <permission_handler/PermissionHandlerPlugin.h>
#else
@import permission_handler;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [Flauto registerWithRegistrar:[registry registrarForPlugin:@"Flauto"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
}

@end
