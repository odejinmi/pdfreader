import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// import 'package:text_to_speech/text_to_speech.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ViewpageController extends GetxController{

  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

 final _formKey = GlobalKey<FormState>().obs;
  set formKey(value) => _formKey.value = value;
  get formKey => _formKey.value;

  final _pdfViewerKey = GlobalKey().obs;
  set pdfViewerKey (value) => _pdfViewerKey.value = value;
  get pdfViewerKey => _pdfViewerKey.value;

  File? file;
  TextEditingController? _textEditingController;

  final _isWeb = false.obs;
  set isWeb (value) => _isWeb.value = value;
  get isWeb => _isWeb.value;

  Color? _textColor;
  Color? disabledColor;
  final  _pdfViewerController = PdfViewerController().obs;
  set pdfViewerController(value) => _pdfViewerController.value = value;
  PdfViewerController get pdfViewerController => _pdfViewerController.value;

  final _focusNodetext = FocusNode().obs;
  set focusNodetext (value) => _focusNodetext.value = value;
  get focusNodetext => _focusNodetext.value;

  // final _searchResult = PdfTextSearchResult().obs;
  // set searchResult(value) => _searchResult.value = value;
  // get searchResult => _searchResult.value;


  final FocusNode _focusNode = FocusNode()..requestFocus();
  Color? color;

  final _pageCount = 0.obs;
  set pageCount (value) => _pageCount.value = value;
  get pageCount => _pageCount.value;
  File? signature;


  PdfDocument? document;
  PdfTextExtractor? extractor;


  final _newVoiceText = "".obs;
  set newVoiceText(value)=> _newVoiceText.value = value;
  get newVoiceText => _newVoiceText.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    initTts();
    pdfViewerController.addListener(pageChanged);
    _textEditingController =
        TextEditingController(text: pdfViewerController.pageNumber.toString());
    file = File(Get.arguments["document"]);
    pageCount = pdfViewerController.pageCount;
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // loadpdf();
    // var currentdocument = GetStorage().read("currentdocument");
    // if (currentdocument != null) {
    //   pdfViewerController.jumpToPage(int.parse(currentdocument));
    // }
  }
  /// Called when the page changes and updates the page number text field.
  Future<void> pageChanged({String? property}) async {
    // if (_isWeb && _zoomLevel != _pdfViewerController.zoomLevel) {
    //   setState(() {
    //     _zoomLevel = _pdfViewerController.zoomLevel;
    //   });
    // }
    if (document == null) {
      await loadpdf();
    }
    if (pageCount != pdfViewerController.pageCount) {
      pageCount = pdfViewerController.pageCount;
    }
    if (_textEditingController!.text !=
        pdfViewerController.pageNumber.toString()) {
      Future<dynamic>.delayed(Duration.zero, () {
        _textEditingController!.text = pdfViewerController.pageNumber.toString();
        update();
      });
    }
  }

Future<void> loadpdf() async {
  //Load the PDF document.
  document = PdfDocument(
      inputBytes: await _readDocumentData(file));

  // //Create PDF text extractor to extract text.
   extractor = PdfTextExtractor(document!);
   update();
}

  // /// Pagination text field widget.
  // Widget paginationTextField(BuildContext context) {
  //   return TextField(
  //     autofocus: false,
  //     style: isWeb
  //         ? TextStyle(
  //         color: _textColor,
  //         fontWeight: FontWeight.w400,
  //         fontStyle: FontStyle.normal,
  //         fontFamily: 'Roboto',
  //         fontSize: 14)
  //         : TextStyle(color: color),
  //     enableInteractiveSelection: false,
  //     keyboardType: TextInputType.number,
  //     controller: _textEditingController,
  //     textAlign: TextAlign.center,
  //     maxLength: isWeb ? 4 : 3,
  //     focusNode: focusNodetext,
  //     maxLines: 1,
  //     decoration: InputDecoration(
  //       counterText: '',
  //       contentPadding: isWeb
  //           ? const EdgeInsets.only(bottom: 22)
  //       // : isDesktop
  //       // ? (const EdgeInsets.only(bottom: 20))
  //           : null,
  //       border: const UnderlineInputBorder(
  //         borderSide: BorderSide(width: 1.0),
  //       ),
  //       focusedBorder: UnderlineInputBorder(
  //         borderSide:
  //         BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
  //       ),
  //     ),
  //     // ignore: avoid_bool_literals_in_conditional_expressions
  //     enabled: pdfViewerController.pageCount == 0 ? false : true,
  //     onTap: pdfViewerController.pageCount == 0
  //         ? null
  //         : () {
  //       _textEditingController!.selection = TextSelection(
  //           baseOffset: 0,
  //           extentOffset: _textEditingController!.value.text.length);
  //       _focusNode.requestFocus();
  //       // widget.onTap?.call('Jump to the page');
  //     },
  //     onSubmitted: (String text) {
  //       _focusNode.unfocus();
  //     },
  //     onEditingComplete: () {
  //       final String str = _textEditingController!.text;
  //       if (str != pdfViewerController.pageNumber.toString()) {
  //         try {
  //           final int index = int.parse(str);
  //           if (index > 0 && index <= pdfViewerController.pageCount) {
  //             pdfViewerController.jumpToPage(index);
  //             FocusScope.of(context).requestFocus(FocusNode());
  //             //widget.onTap?.call('Navigated');
  //           } else {
  //             _textEditingController!.text =
  //                 pdfViewerController.pageNumber.toString();
  //             // showErrorDialog(
  //             //     context, 'Error', 'Please enter a valid page number.');
  //           }
  //         } catch (exception) {
  //         }
  //       }
  //     },
  //   );
  // }

  Future<void> generatePDF() async {
    // //Load the PDF document.
    // document = PdfDocument(
    //     inputBytes: await _readDocumentData(file));

    // //Create PDF text extractor to extract text.
    // extractor = PdfTextExtractor(document);

    //Extract text.
    final String text =
    extractor!.extractText(startPageIndex: int.parse(_textEditingController!.text)-1, endPageIndex: int.parse(_textEditingController!.text)-1);
    newVoiceText = text;
    if (isPlaying || isPaused || isContinued) {
      stop();
    }
    // print(newVoiceText);
    //Show the extracted text.
  }

  void searchtext(String text){
    // for(int i = 0; i < separatedtext.length; i++) {
      //Find the text and get matched items.
      // List<MatchedItem> textCollection =
      // extractor!.findText([separatedtext[0]]);
      // //Get the matched item in the collection using index.
      // MatchedItem matchedText = textCollection[0];
      // //Get the text bounds.
      // Rect textBounds = matchedText.bounds;
      // //Get the page index.
      // int pageIndex = matchedText.pageIndex;
      // //Get the text.
      // String text = matchedText.text;
        pdfViewerController.searchText(text,searchOption: TextSearchOption.wholeWords);
        // searchResult = pdfViewerController.searchText(text,searchOption: TextSearchOption.wholeWords);
        // if (kIsWeb) {
        //   print(
        //       'Total instance count: ${searchResult.totalInstanceCount}');
        // } else {
          // searchResult.addListener(() {
          //   if (searchResult.hasResult &&
          //       searchResult.isSearchCompleted) {
          //     print(
          //         'Total instance count: ${searchResult.totalInstanceCount}');
          //   }
          // });
        // }
    // }
  }



  Future<List<int>> _readDocumentData(name,
      [bool app = false]) async {
    // final ByteData data = await rootBundle.load('assets/pdf/$name');
    //This file is correct
    final ByteData data; // ByteData
    if(!app) {
      final bytes = await name.readAsBytes(); // Uint8List
      data = bytes.buffer.asByteData(); // ByteData
    } else{
      data = await rootBundle.load('$name');
    }
    // if (endpage>data.offsetInBytes) {
    //   setState(() {
    //     endpoint = data.offsetInBytes;
    //   });
    // }else{
    //   endpoint = endpage;
    // }

    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  }

  void continuereading(){
    pdfViewerController.nextPage();
    generatePDF();
    speak();
  }

  late FlutterTts flutterTts;

  final _language = "en-US".obs;
  set language (value) => _language.value = value;
  get language => _language.value;

  final _engine = "".obs;
  set engine (value) => _engine.value = value;
  get engine => _engine.value;

  final _volume = 0.5.obs;
  set volume (value) => _volume.value = value;
  get volume => _volume.value;

  final _pitch = 1.0.obs;
  set pitch (value) => _pitch.value = value;
  get pitch => _pitch.value;

  final _rate = 0.5.obs;
  set rate (value) => _rate.value = value;
  get rate => _rate.value;


  final _ttsState = TtsState.stopped.obs;
  set ttsState(value) => _ttsState.value = value;
  get ttsState => _ttsState.value;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  var _newendoffset = 0.obs;
  set newendoffset (value) => _newendoffset.value = value;
  get newendoffset => _newendoffset.value;

  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState = TtsState.playing;
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        // setState(() {
        print("TTS Initialized");
        // });
      });
    }

    flutterTts.setCompletionHandler(() {
      print("Complete");
      continuereading();
      ttsState = TtsState.stopped;
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState = TtsState.stopped;
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        print("Paused");
        ttsState = TtsState.paused;
      });

      flutterTts.setContinueHandler(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    }

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      ttsState = TtsState.stopped;
    });

    flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      // print("newendoffset"); // Current spoken text
      // print(newendoffset); // Current spoken text
      // print("text"); // Current spoken text
      // print(text.split(" ")[0].length + text.split(" ")[1].length + text.split(" ")[2].length); // Current spoken text
      // if (newendoffset < startOffset) {
      //   RegExp regex = RegExp(r'[\p{P}\p{S}]');
      //   List<String> splitText = text.split(regex);
      //   var textsplit = text.split(" ");
      //   // var textlength = textsplit[0].length + textsplit[1].length + textsplit[2].length + textsplit[3].length;
      //   var textlength = splitText[0].length;
      //   newendoffset = endOffset + textlength;
      // var spokenwords = text.substring(startOffset, newendoffset);
      //   print(spokenwords); // Current spoken text
      //   searchtext(spokenwords);
      // }
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);

    }
  }

  Future speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (newVoiceText.isNotEmpty) {
      await flutterTts.awaitSpeakCompletion(true);
      ttsState = TtsState.playing;
      await flutterTts.speak(newVoiceText);
    }
  }

  Future setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1)  ttsState = TtsState.stopped;
    newendoffset = 0;
  }

  Future pause() async {
    var result = await flutterTts.pause();
    if (result == 1) ttsState = TtsState.paused;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //Dispose the document.
    if(document != null) {
      document!.dispose();
    }
    stop();
  }

  Widget pitchwidget() {
    return Slider(
      value: pitch,
      onChanged: (newPitch) {
        pitch = newPitch;
      },
      min: 0.5,
      max: 2.0,
      divisions: 15,
      label: "Pitch: $pitch",
      activeColor: Colors.red,
    );
  }

  Future<dynamic> getLanguages() async => await flutterTts.getLanguages;

  var _inputLength = 0;
  Widget getMaxSpeechInputLengthSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: const Text('Get max speech input length'),
          onPressed: () async {
            _inputLength = (await flutterTts.getMaxSpeechInputLength)!;
            update();
          },
        ),
        Text(" ${_inputLength} characters"),
      ],
    );
  }

  Widget playpause(){
    return Obx(() {
      return IconButton(
        icon: Icon(
          isStopped ||isPaused ? Icons.play_arrow : Icons.pause,
          color: Colors.black,
          size: 50,
        ),
        onPressed: () {
          if(isStopped ||isPaused ) {
            if(newVoiceText.isEmpty) {
              generatePDF();
            }
            speak();
          }else{
            pause();
          }
        },
      );
    });
  }
  Widget voicecontroller(){
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("The Listener's PDF"),
            const SizedBox(height: 20,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.arrow_back_sharp)),
                const SizedBox(width: 20,),

                playpause(),
                const SizedBox(width: 20,),
                IconButton(onPressed: () {}, icon: const Icon(Icons.forward_5))
              ],
            ),
            const SizedBox(height: 20,),

            if (isAndroid) getMaxSpeechInputLengthSection(),
            const Text("Pitch"),
            pitchwidget(),
            Row(
              children: [
                PopupMenuButton<String>(
                  child: Text("${rate / 0.5}x"),
                  onSelected: (String result) {
                    if (result != "speed") {
                      pause();
                      speak();
                      print("rate");
                      print(double.parse(result) * 0.5);
                      rate = double.parse(result) * 0.5;
                      // controller.speak(newVoiceText);
                      // Handle the option selection
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: "speed",
                      child: Text('Speed', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    const PopupMenuItem<String>(
                      value: "0.75",
                      child: Text('0.75x'),
                    ),
                    const PopupMenuItem<String>(
                      value: '1',
                      child: Text('1x'),
                    ),
                    const PopupMenuItem<String>(
                      value: '1.25',
                      child: Text('1.25x'),
                    ),
                    const PopupMenuItem<String>(
                      value: '1.5',
                      child: Text('1.5x'),
                    ),
                    const PopupMenuItem<String>(
                      value: '2',
                      child: Text('2x'),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("HIDE CONTROLS"),
                ),
                const Spacer(),

                FutureBuilder<dynamic>(
                    future: getLanguages(),
                    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return PopupMenuButton<String>(
                          child: Text(language),
                          onSelected: (String result) {
                            if (result != "lang") {
                              language = result;
                              flutterTts.setLanguage(
                                  language!);
                              if (isAndroid) {
                                flutterTts
                                    .isLanguageInstalled(language!)
                                    .then((value) {});
                              }
                              // Handle the option selection
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: "lang",
                              child: Text("Language", style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            for(int i = 0; i< snapshot.data.length; i++ )
                              PopupMenuItem<String>(
                                value: snapshot.data[i],
                                child: Text(snapshot.data[i]),
                              ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Error loading engines...');
                      } else
                        return const Text('Loading engines...');
                    })
              ],
            ),
          ],
        ),
      );
    });
  }

}

enum TtsState { playing, stopped, paused, continued }