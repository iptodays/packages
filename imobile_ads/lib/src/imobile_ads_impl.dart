// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imobile_ads/src/banner_ad.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'enum.dart';

class ImobileAds {
  /// 是否已初始化
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  /// 是否为测试模式
  static bool _testMode = false;
  static bool get isTestMode => _testMode;

  /// 初始化
  static Future<bool> initialize({
    String? unityId,
    bool testMode = false,
    FirebaseTestLabMode firebaseTestLabMode = FirebaseTestLabMode.disableAds,
  }) async {
    if (isInitialized) return _initialized;
    if (kDebugMode) {
      testMode = true;
    }
    _testMode = testMode;
    if (unityId != null) {
      await UnityAds.init(
        gameId: unityId,
        testMode: testMode,
        firebaseTestLabMode: firebaseTestLabMode,
        onComplete: () {
          if (testMode) {
            print('Unity初始化成功');
          }
        },
        onFailed: (error, errorMessage) {
          if (testMode) {
            print('Unity初始化失败: error: $error msg:$errorMessage');
          }
        },
      );
      for (var element in PrivacyConsentType.values) {
        await UnityAds.setPrivacyConsent(element, true);
      }
    }
    InitializationStatus status = await MobileAds.instance.initialize();
    if (testMode) {
      print('admob初始化: ${status.adapterStatuses}');
    }
    _initialized = true;
    return _initialized;
  }

  /// 更新请求配置
  static Future<void> updateRequestConfiguration({
    String? maxAdContentRating,
    int? tagForChildDirectedTreatment,
    int? tagForUnderAgeOfConsent,
    List<String>? testDeviceIds,
  }) {
    return MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        maxAdContentRating: maxAdContentRating,
        tagForChildDirectedTreatment: tagForChildDirectedTreatment,
        tagForUnderAgeOfConsent: tagForUnderAgeOfConsent,
        testDeviceIds: testDeviceIds,
      ),
    );
  }

  /// 开屏广告
  static Future<void> appOpenAd({
    required String id,
    void Function(IAdmobAppOpenAdState)? callback,
  }) async {
    String unitId = id;
    if (isTestMode) {
      unitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/3419835294'
          : 'ca-app-pub-3940256099942544/5662855259';
    }
    return AppOpenAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (callback != null) {
            callback(IAdmobAppOpenAdState.loaded);
          }
          ad.show();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (callback != null) {
                callback(IAdmobAppOpenAdState.showed);
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (callback != null) {
                callback(IAdmobAppOpenAdState.showFailed);
              }
            },
            onAdWillDismissFullScreenContent: (ad) {
              if (callback != null) {
                callback(IAdmobAppOpenAdState.willDismiss);
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (callback != null) {
                callback(IAdmobAppOpenAdState.dismissed);
              }
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (callback != null) {
            callback(IAdmobAppOpenAdState.loadFailed);
          }
        },
      ),
    );
  }

  /// 横幅广告
  static Widget admobBannerAd({
    required String id,
    AdSize size = AdSize.fullBanner,
    void Function(IAdmobBannerAdState)? callback,
  }) {
    String unitId = id;
    if (isTestMode) {
      unitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return IAdmobBannerAd(
      id: unitId,
      size: size,
      callback: callback,
    );
  }

  /// 插页式广告
  static Future<void> admobInterstitialAd({
    required String id,
    void Function(IAdmobFullScreenAdState)? callback,
  }) async {
    String unitId = id;
    if (isTestMode) {
      unitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          if (callback != null) {
            callback(IAdmobFullScreenAdState.loaded);
          }
          ad.show();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (callback != null) {
                callback(IAdmobFullScreenAdState.showed);
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (callback != null) {
                callback(IAdmobFullScreenAdState.showFailed);
              }
            },
            onAdWillDismissFullScreenContent: (ad) {
              if (callback != null) {
                callback(IAdmobFullScreenAdState.willDismiss);
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (callback != null) {
                callback(IAdmobFullScreenAdState.dismissed);
              }
            },
          );
        },
        onAdFailedToLoad: (error) {
          if (callback != null) {
            callback(IAdmobFullScreenAdState.loadFailed);
          }
        },
      ),
    );
  }

  /// 激励广告
  static Future<void> admobRewardedAd({
    required String id,
    void Function(IAdmobRewardedAdState)? callback,
  }) async {
    String unitId = id;
    if (isTestMode) {
      unitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313';
    }
    RewardedAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (callback != null) {
            callback(IAdmobRewardedAdState.loaded);
          }
          ad.show(
            onUserEarnedReward: (view, item) {
              if (callback != null) {
                callback(IAdmobRewardedAdState.earnedReward);
              }
            },
          );
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (callback != null) {
                callback(IAdmobRewardedAdState.showed);
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (callback != null) {
                callback(IAdmobRewardedAdState.showFailed);
              }
            },
            onAdWillDismissFullScreenContent: (ad) {
              if (callback != null) {
                callback(IAdmobRewardedAdState.willDismiss);
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (callback != null) {
                callback(IAdmobRewardedAdState.dismissed);
              }
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (callback != null) {
            callback(IAdmobRewardedAdState.loadFailed);
          }
        },
      ),
    );
  }

  /// 激励插页广告
  static Future<void> admobRewardedInterstitialAd({
    required String id,
    void Function(IAdmobRewardedAdState)? callback,
  }) async {
    String unitId = id;
    if (isTestMode) {
      unitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5354046379'
          : 'ca-app-pub-3940256099942544/6978759866';
    }
    RewardedInterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (RewardedInterstitialAd ad) {
          if (callback != null) {
            callback(IAdmobRewardedAdState.loaded);
          }
          ad.show(
            onUserEarnedReward: (view, item) {
              if (callback != null) {
                callback(IAdmobRewardedAdState.earnedReward);
              }
            },
          );
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (callback != null) {
                callback(IAdmobRewardedAdState.showed);
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (callback != null) {
                callback(IAdmobRewardedAdState.showFailed);
              }
            },
            onAdWillDismissFullScreenContent: (ad) {
              if (callback != null) {
                callback(IAdmobRewardedAdState.willDismiss);
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (callback != null) {
                callback(IAdmobRewardedAdState.dismissed);
              }
            },
          );
        },
        onAdFailedToLoad: (error) {
          if (callback != null) {
            callback(IAdmobRewardedAdState.loadFailed);
          }
        },
      ),
    );
  }

  /// Unity BannerAd
  static Widget unityBannerAd({
    required String placementId,
    Duration? duration,
    BannerSize size = BannerSize.standard,
    void Function(IUnityBannerAdState)? callback,
  }) {
    return IUnityBannerAd(
      id: placementId,
      size: size,
      duration: duration,
      callback: callback,
    );
  }

  /// Unity 视频广告
  static Future<void> unityVideoAd({
    required String placementId,
    void Function(IUnityVideoAdState)? callback,
  }) async {
    UnityAds.load(
      placementId: placementId,
      onComplete: (_) async {
        await UnityAds.showVideoAd(
          placementId: placementId,
          onStart: (_) {
            if (callback != null) {
              callback(IUnityVideoAdState.start);
            }
          },
          onSkipped: (_) {
            if (callback != null) {
              callback(IUnityVideoAdState.skipped);
            }
          },
          onComplete: (_) {
            if (callback != null) {
              callback(IUnityVideoAdState.complete);
            }
          },
          onFailed: (_, error, message) {
            if (callback != null) {
              callback(IUnityVideoAdState.showFailed);
            }
          },
        );
      },
      onFailed: (placementId, error, message) {
        if (callback != null) {
          callback(IUnityVideoAdState.loadFailed);
        }
      },
    );
  }
}
