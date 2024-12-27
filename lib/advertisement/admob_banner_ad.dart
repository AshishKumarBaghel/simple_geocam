import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../feature/feature_toggle_service.dart';

class AdmobBannerAd extends StatefulWidget {
  /// The requested size of the banner. Defaults to [AdSize.banner].
  final AdSize adSize;

  /// The AdMob ad unit to show.
  final String adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-3940256099942544/9214589741'
      // ... or this one on iOS. (test 'ca-app-pub-3940256099942544/9214589741')
      : 'ca-app-pub-3940256099942544/9214589741';

  AdmobBannerAd({super.key, this.adSize = AdSize.banner});

  @override
  State<AdmobBannerAd> createState() => _AdmobBannerAdState();
}

class _AdmobBannerAdState extends State<AdmobBannerAd> {
  //Let's Add Banner Ad in our Application.
  late BannerAd bannerAd;

  bool isBannerAdLoaded = false;

  bool isAdEnabled = FeatureToggleService.isAdEnabled;

  // A breakpoint for when we consider the screen "tablet-sized" or larger.
  static const double kTabletBreakpoint = 768;

  @override
  Widget build(BuildContext context) {
    // 2) Check if the screen width >= 768 (or any width you desire).
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= kTabletBreakpoint;

    return SizedBox(
      height: getAdHeight(isTablet),
      child: isBannerAdLoaded && isAdEnabled ? AdWidget(ad: bannerAd) : const SizedBox(),
    );
  }

  double getAdHeight(bool isTablet) {
    double height = 0;
    if (isBannerAdLoaded && isAdEnabled) {
      height = isTablet ? 150 : 70;
    }
    return height;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isAdEnabled) {
      bannerAd = BannerAd(
        size: widget.adSize,
        adUnitId: widget.adUnitId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            setState(() {
              isBannerAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: const AdRequest(),
      );
      bannerAd.load();
    }
  }
}
