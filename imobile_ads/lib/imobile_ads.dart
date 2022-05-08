import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

enum ImobileAdsState {
  loaded, // 加载完成
  loadFailed, // 加载失败
  showed, // 已显示
  showFailed, // 显示失败
  willDismiss, // 即将消失
  dismissed, // 消失
  skipped, // 跳过
  earnedReward, // 获得奖励
}

class ImobileAds {
  static const MethodChannel _channel = MethodChannel('imobile_ads');

  /// 是否已初始化
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  /// 是否为测试模式
  static bool _testMode = false;
  static bool get isTestMode => _testMode;

  /// 初始化
  static Future<void> initialize({
    String? unityId,
    bool testMode = false,
    FirebaseTestLabMode firebaseTestLabMode = FirebaseTestLabMode.disableAds,
    Function? onComplete,
    dynamic Function(UnityAdsInitializationError, String)? onFailed,
  }) async {
    _testMode = testMode;
    await MobileAds.instance.initialize();
    if (unityId != null) {
      await UnityAds.init(
        gameId: unityId,
        testMode: testMode,
        firebaseTestLabMode: firebaseTestLabMode,
        onComplete: onComplete,
        onFailed: onFailed,
      );
    }
    _initialized = true;
    return;
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
    int orientation = AppOpenAd.orientationPortrait,
    void Function(ImobileAdsState, AdError?)? callback,
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
            callback(ImobileAdsState.loaded, null);
          }
          ad.show();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (callback != null) {
                callback(ImobileAdsState.showed, null);
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (callback != null) {
                callback(ImobileAdsState.showFailed, error);
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (callback != null) {
                callback(ImobileAdsState.loadFailed, null);
              }
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (callback != null) {
            callback(ImobileAdsState.loadFailed, error);
          }
        },
      ),
      orientation: orientation,
    );
  }

  /// 横幅广告
  static AdWidget bannerAd({
    required String id,
    AdSize size = AdSize.fullBanner,
    void Function(ImobileAdsState, AdError?)? callback,
  }) {
    String unitId = id;
    if (isTestMode) {
      unitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
    return AdWidget(
      ad: BannerAd(
        size: size,
        adUnitId: unitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (callback != null) {
              callback(ImobileAdsState.loaded, null);
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (callback != null) {
              callback(ImobileAdsState.showFailed, error);
            }
          },
          onAdOpened: (ad) {
            if (callback != null) {
              callback(ImobileAdsState.showed, null);
            }
          },
          onAdClosed: (ad) {
            if (callback != null) {
              callback(ImobileAdsState.dismissed, null);
            }
          },
          onAdWillDismissScreen: (ad) {
            if (callback != null) {
              callback(ImobileAdsState.willDismiss, null);
            }
          },
        ),
        request: const AdRequest(),
      ),
    );
  }

  /// 插页式广告
  static Future<void> interstitialAd({
    required String id,
    void Function(ImobileAdsState, AdError?)? callback,
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
            callback(ImobileAdsState.loaded, null);
          }
          ad.show();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (callback != null) {
                callback(ImobileAdsState.showed, null);
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (callback != null) {
                callback(ImobileAdsState.showFailed, error);
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (callback != null) {
                callback(ImobileAdsState.loadFailed, null);
              }
            },
          );
        },
        onAdFailedToLoad: (error) {
          if (callback != null) {
            callback(ImobileAdsState.loadFailed, error);
          }
        },
      ),
    );
  }

  /// 激励广告
  static Future<void> rewardedAd({
    required String id,
    void Function(ImobileAdsState, AdError?)? callback,
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
            callback(ImobileAdsState.loaded, null);
          }
          ad.show(
            onUserEarnedReward: (view, item) {
              if (callback != null) {
                callback(ImobileAdsState.earnedReward, null);
              }
            },
          );
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              if (callback != null) {
                callback(ImobileAdsState.showed, null);
              }
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              if (callback != null) {
                callback(ImobileAdsState.showFailed, error);
              }
            },
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (callback != null) {
                callback(ImobileAdsState.loadFailed, null);
              }
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (callback != null) {
            callback(ImobileAdsState.loadFailed, error);
          }
        },
      ),
    );
  }

  /// Unity BannerAd
  static Widget unityBannerAd({
    required String placementId,
    BannerSize size = BannerSize.standard,
    void Function(ImobileAdsState, UnityAdsBannerError?, String?)? callback,
  }) {
    return UnityBannerAd(
      placementId: placementId,
      size: size,
      onLoad: (_) {
        if (callback != null) {
          callback(ImobileAdsState.loaded, null, null);
        }
      },
      onFailed: (_, error, message) {
        if (callback != null) {
          callback(ImobileAdsState.loadFailed, error, message);
        }
      },
    );
  }

  /// Unity 视频广告
  static Future<void> unityAd({
    required String placementId,
    void Function(ImobileAdsState)? state,
    void Function(UnityAdsLoadError, String)? loadFailed,
    void Function(UnityAdsShowError, String)? showFailed,
  }) async {
    UnityAds.load(
      placementId: placementId,
      onComplete: (_) async {
        await UnityAds.showVideoAd(
          placementId: placementId,
          onStart: (_) {
            if (state != null) {
              state(ImobileAdsState.showed);
            }
          },
          onSkipped: (_) {
            if (state != null) {
              state(ImobileAdsState.skipped);
            }
          },
          onComplete: (_) {
            if (state != null) {
              state(ImobileAdsState.earnedReward);
            }
          },
          onFailed: (_, error, message) {
            if (state != null) {
              state(ImobileAdsState.showFailed);
            }
            if (showFailed != null) {
              showFailed(error, message);
            }
          },
        );
      },
      onFailed: (placementId, error, message) {
        if (state != null) {
          state(ImobileAdsState.loadFailed);
        }
        if (loadFailed != null) {
          loadFailed(error, message);
        }
      },
    );
  }
}
