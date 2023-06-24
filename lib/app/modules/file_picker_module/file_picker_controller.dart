import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class FilePickerController extends GetxController{

  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  var _paths = [].obs;
  set paths (value) => _paths.value = value;
  get paths => _paths.value;

  var _pickingType = FileType.custom.obs;
  set pickingType(value) => _pickingType.value = value;
  get pickingType => _pickingType.value;

  var _image = [].obs;
  set image(value) => _image.value = value;
  get image => _image.value;


  void pickFiles() async {
    resetState();
    try {
      // _directoryPath = null;
      paths = (await FilePicker.platform.pickFiles(
        type: pickingType,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['pdf',],
      ))
          ?.files;
      if(paths!=null) {
        GetStorage().write("currentdocument", paths![0].path.toString());
        Get.toNamed("/viewpage", arguments: {"document": paths![0].path.toString()});
      }
    } on PlatformException catch (e) {
      logException('Unsupported operation' + e.toString());
    } catch (e) {
      logException(e.toString());
    }
    // if (!mounted) return;
      paths != null ? paths!.map((e) => e.name).toString() : '...';

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
  }

  @override
  void onReady() {
    // TODO: implement onReady
    var currentdocument = GetStorage().read("currentdocument");
    if (currentdocument != null && !Platform.isMacOS) {
      Get.toNamed("/viewpage", arguments: {"document": currentdocument});
    }
  }
}
