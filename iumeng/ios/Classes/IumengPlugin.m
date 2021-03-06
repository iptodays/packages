#import "IumengPlugin.h"
#import <UMCommonLog/UMCommonLogManager.h>
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMPush/UMessage.h>
#include<arpa/inet.h>

@interface NSError (FlutterError)
@property(readonly, nonatomic) FlutterError *flutterError;
@end

@implementation NSError (FlutterError)
- (FlutterError *)flutterError {
    return [FlutterError errorWithCode:[NSString stringWithFormat:@"Error %d", (int)self.code]
                               message:self.domain
                               details:self.localizedDescription];
}
@end

@interface IumengPlugin()<UIApplicationDelegate, UNUserNotificationCenterDelegate>

@end

@implementation IumengPlugin {
    NSDictionary *_completeLaunchNotification;
    FlutterMethodChannel *_channel;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"iumeng"
            binaryMessenger:[registrar messenger]];
  IumengPlugin* instance = [[IumengPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"initialize" isEqualToString:call.method]) {
        [self initialize:call.arguments result:result];
      } else if ([@"setProfile" isEqualToString:call.method]) {
          [self setProfile:call.arguments result:result];
      } else if ([@"requestPermission" isEqualToString:call.method]) {
          [self requestPermission:call.arguments result:result];
      } else if ([@"badgeClear" isEqualToString:call.method]) {
          
      } else if ([@"profileSignOff" isEqualToString:call.method]){
          [self profileSignOff:result];
      } else if ([@"logPageView" isEqualToString:call.method]) {
          [self logPageView:call.arguments result:result];
      } else if ([@"beginLogPageView" isEqualToString:call.method]) {
          [self beginLogPageView:call.arguments result:result];
      } else if ([@"endLogPageView" isEqualToString:call.method]) {
          [self endLogPageView:call.arguments result:result];
      } else if ([@"logEvent" isEqualToString:call.method]) {
          [self logEvent:call.arguments result:result];
      } else if ([@"beginEvent" isEqualToString:call.method]) {
          [self beginEvent:call.arguments result:result];
      } else if ([@"endEvent" isEqualToString:call.method]) {
          [self endEvent:call.arguments result:result];
      } else {
        result(FlutterMethodNotImplemented);
      }
    result(nil);
}

/// ?????????
- (void)initialize:(NSDictionary *)args result:(FlutterResult)result {
    if (args[@"logEnabled"]) {
        [UMCommonLogManager setUpUMCommonLogManager];
        [UMConfigure setLogEnabled:true];
    }
    [UMConfigure initWithAppkey:args[@"appKey"] channel:args[@"channel"]];
    result(nil);
}

/// ??????????????????
- (void)requestPermission:(NSDictionary *)args result:(FlutterResult)result {
    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
    bool alert = args[@"alert"];
    bool badge = args[@"badge"];
    bool sound = args[@"sound"];
    if (alert && badge && sound) {
        entity.types = UMessageAuthorizationOptionAlert|
        UMessageAuthorizationOptionBadge|
        UMessageAuthorizationOptionSound;
    } else if (alert && badge && !sound) {
        entity.types = UMessageAuthorizationOptionAlert|
        UMessageAuthorizationOptionBadge;
    } else if (alert && !badge && !sound) {
        entity.types = UMessageAuthorizationOptionAlert;
    } else if (!alert && badge && sound) {
        entity.types = UMessageAuthorizationOptionBadge|
        UMessageAuthorizationOptionSound;
    } else if (!alert && badge && !sound) {
        entity.types = UMessageAuthorizationOptionBadge;
    } else if (!alert && !badge && sound) {
        entity.types = UMessageAuthorizationOptionSound;
    }
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    __weak typeof(self) weakSelf = self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:_completeLaunchNotification
                                                       Entity:entity
                                            completionHandler:^(BOOL result, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSMutableDictionary *arguments = @{
            @"result":@(result),
        }.mutableCopy;
        if (error != nil) {
            [arguments setValue:[error flutterError] forKey:@"error"];
        }
        [strongSelf->_channel invokeMethod:@"registerRemoteNotifications" arguments:arguments];
    }];
    result(nil);
}

/// ??????sdk??????????????????
- (void)badgeClear {
    [UMessage setBadgeClear:true];
}

/// ??????????????????????????????????????????????????????????????????????????????????????????????????????
- (void)setProfile:(NSDictionary *)args result:(FlutterResult)result {
    if ([[args allKeys] containsObject:@"provider"]) {
        [MobClick profileSignInWithPUID:args[@"puid"] provider:args[@"provider"]];
    } else {
        [MobClick profileSignInWithPUID:@"puid"];
    }
    result(nil);
}

///  Signoff???????????????????????????????????????
- (void)profileSignOff:(FlutterResult)result {
    [MobClick profileSignOff];
    result(nil);
}

/// ??????????????????
- (void)logPageView:(NSDictionary *)args result:(FlutterResult)result {
    [MobClick logPageView:args[@"pageName"] seconds:[args[@"seconds"] intValue]];
    result(nil);
}

/// ????????????
- (void)beginLogPageView:(NSDictionary *)args result:(FlutterResult)result {
    [MobClick beginLogPageView:args[@"pageName"]];
    result(nil);
}

/// ????????????
- (void)endLogPageView:(NSDictionary *)args result:(FlutterResult)result {
    [MobClick endLogPageView:args[@"pageName"]];
    result(nil);
}

/// ???????????????
- (void)logEvent:(NSDictionary *)args result:(FlutterResult)result {
    if ([args.allKeys containsObject:@"attributes"] && [args.allKeys containsObject:@"counter"]) {
        [MobClick event:args[@"eventId"]
             attributes:args[@"attributes"]
                counter:[args[@"counter"] intValue]];
    } else if ([args.allKeys containsObject:@"attributes"] && [args.allKeys containsObject:@"millisecond"]) {
        [MobClick event:args[@"eventId"]
             attributes:args[@"attributes"]
              durations:[args[@"millisecond"] intValue]];
    } else if ([args.allKeys containsObject:@"label"] && [args.allKeys containsObject:@"millisecond"]) {
        [MobClick event:args[@"eventId"]
                  label:args[@"label"]
              durations:[args[@"millisecond"] intValue]];
    } else if ([args.allKeys containsObject:@"label"]) {
        [MobClick event:args[@"eventId"] label:args[@"label"]];
    } else if ([args.allKeys containsObject:@"attributes"]) {
        [MobClick event:args[@"eventId"] attributes:args[@"attributes"]];
    }else if ([args.allKeys containsObject:@"millisecond"]) {
        [MobClick event:args[@"eventId"] durations:[args[@"millisecond"] intValue]];
    } else {
        [MobClick event:args[@"eventId"]];
    }
    result(nil);
}

/// ????????????
- (void)beginEvent:(NSDictionary *)args result:(FlutterResult)result {
    if ([args.allKeys containsObject:@"primarykey"] && [args.allKeys containsObject:@"attributes"]) {
        [MobClick beginEvent:args[@"eventId"]
                  primarykey:args[@"primarykey"]
                  attributes:args[@"attributes"]];
    } else if ([args.allKeys containsObject:@"label"]) {
        [MobClick beginEvent:args[@"eventId"] label:args[@"label"]];
    } else {
        [MobClick beginEvent:args[@"eventId"]];
    }
    result(nil);
}

/// ????????????
- (void)endEvent:(NSDictionary *)args result:(FlutterResult)result {
    if ([args.allKeys containsObject:@"primarykey"]) {
        [MobClick endEvent:args[@"eventId"]
                  primarykey:args[@"primarykey"]];
    } else if ([args.allKeys containsObject:@"label"]) {
        [MobClick endEvent:args[@"eventId"] label:args[@"label"]];
    } else {
        [MobClick endEvent:args[@"eventId"]];
    }
    result(nil);
}

#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _completeLaunchNotification = launchOptions;
    return YES;
}

- (void)application:(UIApplication*)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
     if(![deviceToken isKindOfClass:[NSData class]])return;
    const unsigned *tokenBytes =(const unsigned*)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    //1.2.7??????????????????????????????????????????devicetoken???SDK???????????????
    //?????????devicetoken???????????????didRegisterForRemoteNotificationsWithDeviceToken??????????????????
    //[UMessage registerDeviceToken:deviceToken];
    [_channel invokeMethod:@"deviceToken" arguments:@{@"deviceToken":hexToken}];
}

/// iOS10???????????????????????????????????????
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    [UMessage setAutoAlert:NO];
    // ?????????Push??????????????????
    // ??????PushSDK?????????????????????completionHandler(UIBackgroundFetchResultNewData)???
    // ??????????????????completionHandler????????????
    if(![userInfo valueForKeyPath:@"aps.recall"]) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

/// iOS10????????????????????????????????????????????????
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
      willPresentNotification:(UNNotification *)notification
        withCompletionHandler:(void(^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary* userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        [UMessage setAutoAlert:NO];
        // ??????????????????????????????????????????
        // ?????????????????????
       [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        // ??????????????????????????????????????????
    }
    completionHandler(UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionAlert);
}

/// iOS10????????????????????????????????????????????????
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
    // ??????????????????????????????????????????
    // ?????????????????????
    [UMessage didReceiveRemoteNotification:userInfo];
    }else{
    // ??????????????????????????????????????????
    }
}
@end
