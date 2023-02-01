/*
 * @Author: iptoday 
 * @Date: 2022-05-08 16:53:16 
 * @Last Modified by: iptoday
 * @Last Modified time: 2022-05-08 17:05:15
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'enum.dart';

class IAdmobBannerAd extends StatefulWidget {
  const IAdmobBannerAd({
    Key? key,
    required this.id,
    required this.size,
    this.callback,
  }) : super(key: key);

  final String id;

  final AdSize size;

  final void Function(IAdmobBannerAdState)? callback;

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
            widget.callback!(IAdmobBannerAdState.loaded);
          }
          loaded = true;
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (widget.callback != null) {
            widget.callback!(IAdmobBannerAdState.loadFailed);
          }
        },
        onAdOpened: (ad) {
          if (widget.callback != null) {
            widget.callback!(IAdmobBannerAdState.opened);
          }
        },
        onAdClosed: (ad) {
          if (widget.callback != null) {
            widget.callback!(IAdmobBannerAdState.closed);
          }
        },
        onAdWillDismissScreen: (ad) {
          if (widget.callback != null) {
            widget.callback!(IAdmobBannerAdState.willDismiss);
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
    return const SizedBox();
  }

  @override
  bool get wantKeepAlive => true;
}

class IUnityBannerAd extends StatefulWidget {
  const IUnityBannerAd({
    Key? key,
    required this.id,
    required this.size,
    this.duration,
    this.callback,
  }) : super(key: key);

  final String id;

  final BannerSize size;

  final Duration? duration;

  final void Function(IUnityBannerAdState)? callback;

  @override
  State<StatefulWidget> createState() => _IUnityBannerAdState();
}

class _IUnityBannerAdState extends State<IUnityBannerAd>
    with AutomaticKeepAliveClientMixin {
  bool? loaded;

  Timer? timer;

  @override
  void initState() {
    if (widget.duration != null) {
      clocker();
    }
    super.initState();
  }

  Future<void> clocker() async {
    timer?.cancel();
    timer = Timer(
      widget.duration!,
      () {
        setState(() {
          loaded = null;
        });
        clocker();
      },
    );
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
            if (widget.callback != null) {
              widget.callback!(IUnityBannerAdState.loaded);
            }
          },
          onFailed: (_, error, mgs) {
            setState(() {
              loaded = false;
            });
            if (widget.callback != null) {
              widget.callback!(IUnityBannerAdState.loadFailed);
            }
          },
        ),
      );
    }
    return const SizedBox();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
