#import "IumengPlugin.h"
#if __has_include(<iumeng/iumeng-Swift.h>)
#import <iumeng/iumeng-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "iumeng-Swift.h"
#endif

@implementation IumengPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIumengPlugin registerWithRegistrar:registrar];
}
@end
