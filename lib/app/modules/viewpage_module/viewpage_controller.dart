import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  final FocusNode _focusNode = FocusNode()..requestFocus();
  Color? color;

  final _pageCount = 0.obs;
  set pageCount (value) => _pageCount.value = value;
  get pageCount => _pageCount.value;
  File? signature;

  final _newVoiceText = "".obs;
  set newVoiceText(value)=> _newVoiceText.value = value;
  get newVoiceText => newVoiceText.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    pdfViewerController.addListener(pageChanged);
    _textEditingController =
        TextEditingController(text: pdfViewerController.pageNumber.toString());
    file = File(Get.arguments["document"]);
    pageCount = pdfViewerController.pageCount;


    initTts();
    // initLanguages();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // var currentdocument = GetStorage().read("currentdocument");
    // if (currentdocument != null) {
    //   pdfViewerController.jumpToPage(int.parse(currentdocument));
    // }
  }
  /// Called when the page changes and updates the page number text field.
  void pageChanged({String? property}) {
    // if (_isWeb && _zoomLevel != _pdfViewerController.zoomLevel) {
    //   setState(() {
    //     _zoomLevel = _pdfViewerController.zoomLevel;
    //   });
    // }
    if (pageCount != pdfViewerController.pageCount) {
      pageCount = pdfViewerController.pageCount;
    }
    if (_textEditingController!.text !=
        pdfViewerController.pageNumber.toString()) {
      Future<dynamic>.delayed(Duration.zero, () {
        _textEditingController!.text = pdfViewerController.pageNumber.toString();
        GetStorage().write("currentpage", pdfViewerController.pageNumber.toString());
        generatePDF();
        update();
      });
    }
  }



  /// Pagination text field widget.
  Widget paginationTextField(BuildContext context) {
    return TextField(
      autofocus: false,
      style: isWeb
          ? TextStyle(
          color: _textColor,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          fontFamily: 'Roboto',
          fontSize: 14)
          : TextStyle(color: color),
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      controller: _textEditingController,
      textAlign: TextAlign.center,
      maxLength: isWeb ? 4 : 3,
      focusNode: focusNodetext,
      maxLines: 1,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: isWeb
            ? const EdgeInsets.only(bottom: 22)
        // : isDesktop
        // ? (const EdgeInsets.only(bottom: 20))
            : null,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
          BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
      ),
      // ignore: avoid_bool_literals_in_conditional_expressions
      enabled: pdfViewerController.pageCount == 0 ? false : true,
      onTap: pdfViewerController.pageCount == 0
          ? null
          : () {
        _textEditingController!.selection = TextSelection(
            baseOffset: 0,
            extentOffset: _textEditingController!.value.text.length);
        _focusNode.requestFocus();
        // widget.onTap?.call('Jump to the page');
      },
      onSubmitted: (String text) {
        _focusNode.unfocus();
      },
      onEditingComplete: () {
        final String str = _textEditingController!.text;
        if (str != pdfViewerController.pageNumber.toString()) {
          try {
            final int index = int.parse(str);
            if (index > 0 && index <= pdfViewerController.pageCount) {
              pdfViewerController.jumpToPage(index);
              FocusScope.of(context).requestFocus(FocusNode());
              //widget.onTap?.call('Navigated');
            } else {
              _textEditingController!.text =
                  pdfViewerController.pageNumber.toString();
              // showErrorDialog(
              //     context, 'Error', 'Please enter a valid page number.');
            }
          } catch (exception) {
          }
        }
      },
    );
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


  Future<void> generatePDF() async {
    //Load the PDF document.
    final PdfDocument document = PdfDocument(
        inputBytes: await _readDocumentData(file));

    //Create PDF text extractor to extract text.
    final PdfTextExtractor extractor = PdfTextExtractor(document);

    //Extract text.
    final String text =
    extractor.extractText(startPageIndex: int.parse(pdfViewerController.pageNumber.toString())-1, endPageIndex: int.parse(pdfViewerController.pageNumber.toString())-1);

    //Dispose the document.
    document.dispose();
    newVoiceText = text;
    print(newVoiceText);
    //Show the extracted text.
  }

  void continuereading(){
    pdfViewerController.nextPage();
    generatePDF();
  }

  late FlutterTts flutterTts;

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

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;



  initTts() {
    flutterTts = FlutterTts();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState = TtsState.playing;
    });

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
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future speak() async {
    if(ttsState == TtsState.stopped) {
      await flutterTts.setVolume(volume);
      await flutterTts.setSpeechRate(rate);
      await flutterTts.setPitch(pitch);

      if (newVoiceText!.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(newVoiceText!);
      }
    }else{
      var result = await flutterTts.stop();
      if (result == 1) ttsState = TtsState.stopped;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterTts.stop();
  }

}

enum TtsState { playing, stopped, paused, continued }