import 'package:pdfreader/app/modules/file_picker_module/file_picker_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class FilePickerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FilePickerController());
  }
}