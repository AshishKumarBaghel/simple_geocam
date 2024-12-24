import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../feature/feature_toggle_service.dart';

class AdmobInterstitialAd {
  /// The AdMob ad unit to show.
  final String adUnitId = Platform.isAndroid
      // Use this ad unit on Android...
      ? 'ca-app-pub-3940256099942544/1033173712'
      // ... or this one on iOS. (test 'ca-app-pub-3940256099942544/1033173712')
      : 'ca-app-pub-3940256099942544/1033173712';

  late InterstitialAd _interstitialAd;
  bool _isAdLoaded = false;
  bool isAdEnabled = FeatureToggleService.isAdEnabled;

  /// Load the interstitial ad.
  void loadAd() {
    if (isAdEnabled) {
      InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _isAdLoaded = true;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _isAdLoaded = false;
          },
        ),
      );
    }
  }

  /// Show the interstitial ad and navigate to home after dismissal.
  void showAdAndNavigate(BuildContext context, VoidCallback onAdDismissed) {
    if (_isAdLoaded && isAdEnabled) {
      _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadAd(); // Preload a new ad after the current one is shown.
          onAdDismissed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          onAdDismissed();
        },
      );
      _interstitialAd.show();
      _isAdLoaded = false; // Mark as not loaded to avoid multiple shows.
    } else {
      onAdDismissed();
    }
  }

  /// Dispose of the interstitial ad if needed.
  void dispose() {
    _interstitialAd.dispose();
  }
}
