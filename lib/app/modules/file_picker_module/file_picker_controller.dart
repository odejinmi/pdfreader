import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfreader/app/data/provider/datamodel.dart';

import '../../data/provider/database.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class FilePickerController extends GetxController with GetTickerProviderStateMixin{

  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final _documenttype = "pdf".obs;
  set documenttype(value) => _documenttype.value = value;
  get documenttype => _documenttype.value;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final _paths = [].obs;
  set paths (value) => _paths.value = value;
  get paths => _paths.value;

  final _pickingType = FileType.custom.obs;
  set pickingType(value) => _pickingType.value = value;
  get pickingType => _pickingType.value;

  final _image = [].obs;
  set image(value) => _image.value = value;
  get image => _image.value;

  final _currentindex = 0.obs;
  set currentindex(value) => _currentindex.value=value;
  get currentindex => _currentindex.value;

  final _primarycolour = const Color(0xffFE1643).obs;
  set primarycolour(value) => _primarycolour.value=value;
  get primarycolour => _primarycolour.value;

  final _documentviewed = [].obs;
  set documentviewed(value) => _documentviewed.value = value;
  get documentviewed => _documentviewed.value;

  final _documentfetch = [].obs;
  set documentfetch(value) => _documentfetch.value = value;
  get documentfetch => _documentfetch.value;



  TabController? tabController;


  final _showFab = true.obs;
  set showFab(value) => _showFab.value = value;
  get showFab => _showFab.value;

  void pickFiles() async {
    resetState();
    var now = DateTime.now();
    var formatter = DateFormat('dd-MM-yyy hh:MM a');
    String formattedDate = formatter.format(now);
    try {
      // _directoryPath = null;
      paths = (await FilePicker.platform.pickFiles(
        type: pickingType,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: [documenttype,],
      ))
          ?.files;
      if(paths!=null) {
        var path = paths![0].path.toString();
         var result = documentfetch.where((v) {
           return v.path.toLowerCase() == path.toLowerCase();
         }).toList();
        String returnsize = await _getFileSize(path);
        if (result.isEmpty) {
          await insertContact(
              Datamodel(path: path,
                  name: path.split('/').last.replaceAll(".$documenttype", ''),
                  type: documenttype,
                  current: 1,datecreated: formattedDate, filesized: returnsize), "document");
        }
        openfiles(path);
      }
    } on PlatformException catch (e) {
      logException('Unsupported operation$e');
    } catch (e) {
      logException(e.toString());
    }
    // if (!mounted) return;
      paths != null ? paths!.map((e) => e.name).toString() : '...';

  }

  updated(document) async {
    await deleteContact(document);
    documentviewed.remove(document);
  }

  Future<String> _getFileSize(String path) async {
    final fileBytes = await File(path).readAsBytes();
      final size = fileBytes.lengthInBytes;
    final fileSizeInKB = size / 1000;
    final fileSizeInMB = fileSizeInKB / 1000;
    final fileSizeInGB = fileSizeInMB / 1000;
    final fileSizeInTB = fileSizeInGB / 1000;
    print("size in byte $size");
    print("size in kilobyte $fileSizeInKB");
    print("size in megabyte $fileSizeInMB");
    print("size in gigabyte $fileSizeInGB");
    print("size in terabyte $fileSizeInTB");
      switch (size){
        case > 1000000 :
          return "${(size/1000000).toStringAsFixed(1)} MB";
        case > 1000000000 :
          return "${(size/1000000000).toStringAsFixed(1)} GB";
         case > 1000000000000 :
          return "${(size/1000000000000).toStringAsFixed(1)} GB";
        default:
          return "${(size/1000).ceil()} KB";
      }
  }

  void openfiles(String path){
    Get.toNamed("/viewpage", arguments: {"document": path});
  }
  void logException(String message) {
    print(message);
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void resetState() {
    // if (!mounted) {
    //   return;
    // }
      paths = [];
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetch(documenttype);
    tabController = TabController(vsync: this, initialIndex: 0, length: 2);
    tabController!.addListener(() {
      if (tabController!.index == 1) {
        documenttype = "doc";
        primarycolour = const Color(0xff144FB3);
      } else {
        documenttype = "pdf";
        primarycolour = const Color(0xffFE1643);
      }
      fetch(documenttype);
    });
  }

  Future<void> fetch(String documenttype) async {
    documentfetch =  datamodelFromJson(jsonEncode(
        await fetchspecificContact("type= ?", [documenttype], "document")));
    sort("document");
  }

  void sort(String sort) {
    List ade = documentfetch;
    switch (sort) {
      case "name":
      var result =
            documentfetch.sort((a, b) => b.path.toString().compareTo(a.path));
      print(result);
      case "size":
        documentviewed =
            documentfetch.sort((a, b) => a.filesized.toString().compareTo(b.filesized));
      case "modified":
        documentviewed =
            documentfetch.sort((a, b) => a.datecreated.toString().compareTo(b.datecreated));
      default :
        documentviewed = documentfetch;
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    // var currentdocument = GetStorage().read("currentdocument");
    // if (currentdocument != null && !Platform.isMacOS) {
    //   Get.toNamed("/viewpage", arguments: {"document": currentdocument});
    // }
  }
}
