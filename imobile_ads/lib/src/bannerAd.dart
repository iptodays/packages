/*
 * @Author: iptoday 
 * @Date: 2022-05-08 16:53:16 
 * @Last Modified by: iptoday
 * @Last Modified time: 2022-05-08 17:05:15
 */
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imobile_ads/src/enum.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class IAdmobBannerAd extends StatefulWidget {
  const IAdmobBannerAd({
    Key? key,
    required this.id,
    required this.size,
    this.callback,
  }) : super(key: key);

  final String id;

  final AdSize size;

  final void Function(ImobileAdsState, AdError?)? callback;

  @override
  State<StatefulWidget> createState() => _IAdmobBannerAdState();
}

class _IAdmobBannerAdState extends State<IAdmobBannerAd>
    with AutomaticKeepAliveClientMixin {
  bool loaded = false;

  late BannerAd bannerAd;

  @override
  void initState() {
    bannerAd = BannerAd(
      size: widget.size,
      adUnitId: widget.id,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.loaded, null);
          }
          loaded = true;
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.loadFailed, error);
          }
        },
        onAdOpened: (ad) {
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.showed, null);
          }
        },
        onAdClosed: (ad) {
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.dismissed, null);
          }
        },
        onAdWillDismissScreen: (ad) {
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.willDismiss, null);
          }
        },
      ),
      request: const AdRequest(),
    );
    bannerAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loaded) {
      return Container(
        height: widget.size.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: bannerAd),
      );
    }
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}

class IUnityBannerAd extends StatefulWidget {
  const IUnityBannerAd({
    Key? key,
    required this.id,
    required this.size,
    this.callback,
  }) : super(key: key);

  final String id;

  final BannerSize size;

  final void Function(ImobileAdsState, AdError?)? callback;

  @override
  State<StatefulWidget> createState() => _IUnityBannerAdState();
}

class _IUnityBannerAdState extends State<IUnityBannerAd>
    with AutomaticKeepAliveClientMixin {
  bool? loaded;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loaded == null || loaded!) {
      return Container(
        height: widget.size.height.toDouble(),
        alignment: Alignment.center,
        child: UnityBannerAd(
          size: widget.size,
          placementId: widget.id,
          onLoad: (_) {
            setState(() {
              loaded = true;
            });
          },
          onFailed: (_, error, mgs) {
            setState(() {
              loaded = false;
            });
          },
        ),
      );
    }
    return Container();
  }

  @override
  bool get wantKeepAlive => true;
}
