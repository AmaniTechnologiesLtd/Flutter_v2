#import "FlutterAmanisdkPlugin.h"
#if __has_include(<flutter_amanisdk/flutter_amanisdk-Swift.h>)
#import <flutter_amanisdk/flutter_amanisdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_amanisdk-Swift.h"
#endif

@implementation FlutterAmanisdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAmanisdkPlugin registerWithRegistrar:registrar];
}
@end
