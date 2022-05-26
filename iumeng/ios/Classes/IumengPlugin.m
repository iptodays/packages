#import "IumengPlugin.h"
#import <UMCommonLog/UMCommonLogManager.h>
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMPush/UMessage.h>
#include<arpa/inet.h>

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

/// 初始化
- (void)initialize:(NSDictionary *)args result:(FlutterResult)result {
    if (args[@"logEnabled"]) {
        [UMCommonLogManager setUpUMCommonLogManager];
        [UMConfigure setLogEnabled:true];
    }
    [UMConfigure initWithAppkey:args[@"appKey"] channel:args[@"channel"]];
    result(nil);
}

/// 请求推送权限
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
            [arguments setValue:@(error.code) forKey:@"errorCode"];
            [arguments setValue:error.description forKey:@"errorMessage"];
        }
        [strongSelf->_channel invokeMethod:@"registerRemoteNotifications" arguments:arguments];
    }];
    result(nil);
}

/// 允许sdk自动清空角标
- (void)badgeClear {
    [UMessage setBadgeClear:true];
}

/// 在统计用户时以设备为标准，如果需要统计应用自身的账号，可以使用此功能
- (void)setProfile:(NSDictionary *)args result:(FlutterResult)result {
    if ([[args allKeys] containsObject:@"provider"]) {
        [MobClick profileSignInWithPUID:args[@"puid"] provider:args[@"provider"]];
    } else {
        [MobClick profileSignInWithPUID:@"puid"];
    }
    result(nil);
}

///  Signoff调用后，不再发送账号内容。
- (void)profileSignOff:(FlutterResult)result {
    [MobClick profileSignOff];
    result(nil);
}

/// 统计页面时长
- (void)logPageView:(NSDictionary *)args result:(FlutterResult)result {
    [MobClick logPageView:args[@"pageName"] seconds:[args[@"seconds"] intValue]];
    result(nil);
}

/// 进入页面
- (void)beginLogPageView:(NSDictionary *)args result:(FlutterResult)result {
    [MobClick beginLogPageView:args[@"pageName"]];
    result(nil);
}

/// 离开页面
- (void)endLogPageView:(NSDictionary *)args result:(FlutterResult)result {
    [MobClick endLogPageView:args[@"pageName"]];
    result(nil);
}

/// 自定义事件
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

/// 事件开始
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

/// 事件结束
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
    NSLog(@"获取launchOptions");
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
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    //传入的devicetoken是系统回调didRegisterForRemoteNotificationsWithDeviceToken的入参，切记
    //[UMessage registerDeviceToken:deviceToken];
    NSLog(@"获取%@", hexToken);
    [_channel invokeMethod:@"deviceToken" arguments:@{@"deviceToken":hexToken}];
}

/// iOS10以下使用这两个方法接收通知
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    [UMessage setAutoAlert:NO];
    // 过滤掉Push的撤销功能，
    // 因为PushSDK内部已经调用的completionHandler(UIBackgroundFetchResultNewData)，
    // 防止两次调用completionHandler引起崩溃
    if(![userInfo valueForKeyPath:@"aps.recall"]) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

/// iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
      willPresentNotification:(UNNotification *)notification
        withCompletionHandler:(void(^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary* userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
        [UMessage setAutoAlert:NO];
        // 应用处于前台时的远程推送接受
        // 必须加这句代码
       [UMessage didReceiveRemoteNotification:userInfo];
    }else{
        // 应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionAlert);
}

/// iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
    // 应用处于后台时的远程推送接受
    // 必须加这句代码
    [UMessage didReceiveRemoteNotification:userInfo];
    }else{
    // 应用处于后台时的本地推送接受
    }
}
@end
