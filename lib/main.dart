import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/services/ad_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Advert SDK globally
  AdService().initialize(testMode: false);

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff2563EB), // Modern Blue
          primary: const Color(0xff2563EB),
          surface: const Color(0xffF8FAFC),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Assuming standard font, but we'll use clean styles
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
        ),
        appBarTheme: const AppBarThemeData(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xff1E293B),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xff1E293B),
          ),
        ),
      ),
      initialRoute: Routes.SPLASH,
      getPages: AppPages.pages,
      // home: LandingPage(),
    );
  }
}
