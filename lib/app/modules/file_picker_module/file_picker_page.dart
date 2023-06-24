
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader/app/modules/file_picker_module/file_picker_controller.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class FilePickerPage extends GetView<FilePickerController> {



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: controller.scaffoldMessengerKey,
      home: Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          title: const Text('File Picker example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => controller.pickFiles(),
                          child: const Text('Pick file'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
