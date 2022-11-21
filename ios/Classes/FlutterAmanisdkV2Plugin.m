#import "FlutterAmanisdkV2Plugin.h"
#if __has_include(<flutter_amanisdk_v2/flutter_amanisdk_v2-Swift.h>)
#import <flutter_amanisdk_v2/flutter_amanisdk_v2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_amanisdk_v2-Swift.h"
#endif

@implementation FlutterAmanisdkV2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAmanisdkV2Plugin registerWithRegistrar:registrar];
}
@end
