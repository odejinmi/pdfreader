// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:get/get.dart';
//
// class ReadController extends GetxController{
//
//   late FlutterTts flutterTts;
//
//   final _volume = 0.5.obs;
//   set volume (value) => _volume.value = value;
//   get volume => _volume.value;
//
//   final _pitch = 1.0.obs;
//   set pitch (value) => _pitch.value = value;
//   get pitch => _pitch.value;
//
//   final _rate = 0.5.obs;
//   set rate (value) => _rate.value = value;
//   get rate => _rate.value;
//
//   final _isplaying = false.obs;
//   set isplaying(value) => _isplaying.value = value;
//   get isplaying => _isplaying.value;
//
//
//   final _ttsState = TtsState.stopped.obs;
//   set ttsState(value) => _ttsState.value = value;
//   get ttsState => _ttsState.value;
//
//   bool get isIOS => !kIsWeb && Platform.isIOS;
//   bool get isAndroid => !kIsWeb && Platform.isAndroid;
//   bool get isWeb => kIsWeb;
//
//
//
//   initTts() {
//     flutterTts = FlutterTts();
//
//     if (isAndroid) {
//       _getDefaultEngine();
//     }
//
//     flutterTts.setStartHandler(() {
//         print("Playing");
//         ttsState = TtsState.playing;
//     });
//
//     flutterTts.setCompletionHandler(() {
//         print("Complete");
//         ttsState = TtsState.stopped;
//     });
//
//     flutterTts.setCancelHandler(() {
//         print("Cancel");
//         ttsState = TtsState.stopped;
//     });
//
//     if (isWeb || isIOS) {
//       flutterTts.setPauseHandler(() {
//           print("Paused");
//           ttsState = TtsState.paused;
//       });
//
//       flutterTts.setContinueHandler(() {
//           print("Continued");
//           ttsState = TtsState.continued;
//       });
//     }
//
//     flutterTts.setErrorHandler((msg) {
//         print("error: $msg");
//         ttsState = TtsState.stopped;
//       });
//   }
//
//   Future _getDefaultEngine() async {
//     var engine = await flutterTts.getDefaultEngine;
//     if (engine != null) {
//       print(engine);
//     }
//   }
//
//   Future speak(newVoiceText) async {
//     if(!isplaying) {
//       await flutterTts.setVolume(volume);
//       await flutterTts.setSpeechRate(rate);
//       await flutterTts.setPitch(pitch);
//
//       if (newVoiceText != null) {
//         if (newVoiceText!.isNotEmpty) {
//             isplaying = true;
//           await flutterTts.awaitSpeakCompletion(true);
//           await flutterTts.speak(newVoiceText!);
//         }
//       }
//     }else{
//         isplaying = false;
//       var result = await flutterTts.stop();
//       if (result == 1) ttsState = TtsState.stopped;
//     }
//   }
//
//   @override
//   void onInit() {
//     // TODO: implement onInit
//     super.onInit();
//     initTts();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     flutterTts.stop();
//   }
// }
//
// enum TtsState { playing, stopped, paused, continued }