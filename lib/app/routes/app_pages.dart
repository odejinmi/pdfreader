import '../../app/modules/search_module/search_page.dart';
import '../../app/modules/search_module/search_bindings.dart';
import '../../app/modules/viewpage_module/viewpage_page.dart';
import '../../app/modules/viewpage_module/viewpage_bindings.dart';
import '../../app/modules/file_picker_module/file_picker_bindings.dart';
import '../../app/modules/file_picker_module/file_picker_page.dart';
import '../../app/modules/splash_module/splash_page.dart';
import '../../app/modules/splash_module/splash_bindings.dart';
import 'package:get/get.dart';
part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.FILE_PICKER,
      page: () => const FilePickerPage(),
      binding: FilePickerBinding(),
    ),
    GetPage(
      name: Routes.VIEWPAGE,
      page: () => const ViewpagePage(),
      binding: ViewpageBinding(),
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => const SearchPage(),
      binding: SearchBinding(),
    ),
  ];
}
