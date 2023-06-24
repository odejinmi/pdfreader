import 'package:pdfreader/app/modules/viewpage_module/viewpage_controller.dart';
import 'package:get/get.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ViewpageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ViewpageController());
  }
}