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
    this.failure,
  }) : super(key: key);

  final String id;

  final AdSize size;

  final void Function(ImobileAdsState)? callback;

  final void Function(AdError)? failure;

  @override
  State<StatefulWidget> createState() => _CustomBannerAdState();
}

class _CustomBannerAdState extends State<CustomBannerAd>
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
            widget.callback!(ImobileAdsState.loaded);
          }
          loaded = true;
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.loadFailed);
          }
          if (widget.failure != null) {
            widget.failure!(error);
          }
        },
        onAdOpened: (ad) {
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.showed);
          }
        },
        onAdClosed: (ad) {
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.dismissed);
          }
        },
        onAdWillDismissScreen: (ad) {
          if (widget.callback != null) {
            widget.callback!(ImobileAdsState.willDismiss);
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
