#import "ImobileAdsPlugin.h"
#if __has_include(<imobile_ads/imobile_ads-Swift.h>)
#import <imobile_ads/imobile_ads-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "imobile_ads-Swift.h"
#endif

@implementation ImobileAdsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImobileAdsPlugin registerWithRegistrar:registrar];
}
@end
