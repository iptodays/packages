#import "SkanPlugin.h"
#if __has_include(<skan/skan-Swift.h>)
#import <skan/skan-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "skan-Swift.h"
#endif

@implementation SkanPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSkanPlugin registerWithRegistrar:registrar];
}
@end
