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
  bool isFailed = false;

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
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (widget.callback != null) {
            widget.callback!(IAdmobBannerAdState.loadFailed);
          }
          setState(() {
            isFailed = true;
          });
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
    if (isFailed) {
      return const SizedBox();
    }
    return Container(
      height: widget.size.height.toDouble(),
      alignment: Alignment.center,
      child: AdWidget(ad: bannerAd),
    );
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
  bool isFailed = false;

  bool refresh = false;

  Timer? timer;

  Future<void> clocker() async {
    if (timer != null && timer!.isActive) {
      timer?.cancel();
    }
    await Future.delayed(const Duration(milliseconds: 100));
    timer = Timer(
      widget.duration!,
      () {
        setState(() => refresh = true);
        Future.delayed(const Duration(milliseconds: 100)).then((_) {
          setState(() => refresh = false);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isFailed) {
      return const SizedBox();
    }
    return Container(
      height: widget.size.height.toDouble(),
      alignment: Alignment.center,
      child: Builder(builder: (_) {
        if (refresh) {
          return const SizedBox();
        }
        return UnityBannerAd(
          size: widget.size,
          placementId: widget.id,
          onLoad: (_) {
            if (widget.callback != null) {
              widget.callback!(IUnityBannerAdState.loaded);
            }
            if (widget.duration != null) {
              clocker();
            }
          },
          onFailed: (_, error, mgs) {
            if (widget.callback != null) {
              widget.callback!(IUnityBannerAdState.loadFailed);
            }
            setState(() {
              isFailed = true;
            });
          },
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
