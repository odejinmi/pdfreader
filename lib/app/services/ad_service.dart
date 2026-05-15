import 'dart:io';

import 'package:advert/advert.dart';
import 'package:flutter/material.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  final Advert _advert = Advert();


  static final String bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/3174487502'
      : 'ca-app-pub-6117361441866120/1488443500';

  static final String rewardVideoUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/7345437893'
      : 'ca-app-pub-6117361441866120/2609953488';

  static String interstitialUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/9548324168'
      : 'ca-app-pub-6117361441866120/8759030065';

  static String rewardInterstitialUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/5980385332'
      : 'ca-app-pub-6117361441866120/6040874481';


  // final gameid = Platform.isAndroid ? "3717787" : '3717786';
  // final bannerAdPlacementId =
  // Platform.isAndroid ? ['newandroidbanner'] : ['iOS_Banner'];
  // final interstitialVideoAdPlacementId =
  // Platform.isAndroid ? ['video'] : ['iOS_Interstitial'];
  // final rewardedVideoAdPlacementId = Platform.isAndroid
  //     ? ['Android_Rewarded', "rewardedVideo"]
  //     : ['iOS_Rewarded'];
  /// Initialize the Ad SDK
  void initialize({bool testMode = true}) {
    Googlemodel googlemodel = Googlemodel()
      ..bannerAdUnitId = [bannerAdUnitId]
      ..rewardedInterstitialAdUnitId = [rewardInterstitialUnitId]
      ..rewardedAdUnitId = [rewardVideoUnitId]
      ..spinAndWin = [rewardVideoUnitId]
      ..freemoney = [rewardVideoUnitId]
      ..interstitialAdUnitId = [interstitialUnitId];
    // Unitymodel unitymodel = Unitymodel()
    //   ..gameId = gameid
    //   ..interstitialVideoAdPlacementId = interstitialVideoAdPlacementId
    //   ..rewardedVideoAdPlacementId = rewardedVideoAdPlacementId
    //   ..bannerAdPlacementId = bannerAdPlacementId;
    _advert.initialize(testmode: testMode, adsmodel: Adsmodel(googlemodel: googlemodel));
    
    // Preload ads so they are ready when showInterstitial or showRewarded is called
    _advert.adsProv.preloadAllAds();
  }

  /// Show Interstitial Ad
  void showInterstitial({
    Function? onAdClicked,
    Function? onAdImpression,
    Function? onAdDismissed,
  }) {
    _advert.adsProv.showInterstitialAd( onAdClicked: onAdClicked, onAdImpression: onAdImpression, onAdDismissed: onAdDismissed);
  }

  /// Show Rewarded Ad with a callback
  void showRewarded(VoidCallback onRewardEarned, {Map<String, String>? customData}) {
    _advert.adsProv.showRewardedAd(
      onRewarded: onRewardEarned,
       customData: customData ?? {"app": "lumina_reader"},
    );
  }

  /// Get Banner Ad Widget
  Widget getBannerAd() {
    return _advert.adsProv.showBannerAd();
  }

  /// Get Native Ad Widget
  Widget getNativeAd(BuildContext context) {
    return _advert.adsProv.showNativeAd(context);
  }

  /// Start an Ad Sequence
  void startSequence(BuildContext context, {
    required int total,
    required String adType,
    required String reason,
    required VoidCallback onComplete,
    Map<String, String>? customData,
  }) {
    _advert.adsProv.startAdSequence(
      context,
      total: total,
      adType: adType,
      reason: reason,
      onComplete: onComplete, customData: customData??{"app": "lumina_reader"},
    );
  }
}
