#import "IleboPlugin.h"
#if __has_include(<ilebo/ilebo-Swift.h>)
#import <ilebo/ilebo-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ilebo-Swift.h"
#endif

@implementation IleboPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIleboPlugin registerWithRegistrar:registrar];
}
@end
