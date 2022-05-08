/*
 * @Author: iptoday 
 * @Date: 2022-05-08 16:53:16 
 * @Last Modified by: iptoday
 * @Last Modified time: 2022-05-08 17:05:15
 */
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:imobile_ads/enum.dart';

class CustomBannerAd extends StatefulWidget {
  const CustomBannerAd({
    Key? key,
    required this.id,
    required this.size,
    this.callback,
  }) : super(key: key);

  final String id;

  final AdSize size;

  final void Function(ImobileAdsState, AdError?)? callback;

  @override
  State<StatefulWidget> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd> {
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
            widget.callback!(ImobileAdsState.showFailed, error);
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
    if (loaded) {
      return AdWidget(ad: bannerAd);
    }
    return Container();
  }
}
