import '../../app/modules/viewpage_module/viewpage_page.dart';
import '../../app/modules/viewpage_module/viewpage_bindings.dart';
import '../../app/modules/file_picker_module/file_picker_bindings.dart';
import '../../app/modules/file_picker_module/file_picker_page.dart';
import 'package:get/get.dart';
part './app_routes.dart';
/**
 * GetX Generator - fb.com/htngu.99
 * */

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.FILE_PICKER,
      page: () => FilePickerPage(),
      binding: FilePickerBinding(),
    ),
    GetPage(
      name: Routes.VIEWPAGE,
      page: () => ViewpagePage(),
      binding: ViewpageBinding(),
    ),
  ];
}
