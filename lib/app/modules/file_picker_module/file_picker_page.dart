import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader/app/data/provider/datamodel.dart';
import 'package:pdfreader/app/data/provider/listitem.dart';
import 'package:pdfreader/app/modules/file_picker_module/file_picker_controller.dart';

import '../../data/provider/database.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class FilePickerPage extends GetView<FilePickerController> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: controller.scaffoldMessengerKey,
      home: Obx(() {
        return Scaffold(
          key: controller.scaffoldKey,
          appBar: AppBar(
            title: const Text('PDF Reader'),
            backgroundColor: controller.primarycolour,
            bottom: TabBar(
              controller: controller.tabController,
              indicatorColor: Colors.white,
              tabs: const <Widget>[
                Tab(text: "PDF"),
                Tab(
                  text: "WORD",
                ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () async {},
                  icon: const Icon(Icons.diamond_outlined)
              ),
              IconButton(onPressed: () {
                Get.toNamed("/search", arguments: {
                  "document": controller.documentviewed,
                  "primarycolour": controller.primarycolour,
                  "documenttype": controller.documenttype
                });
              }, icon: const Icon(Icons.search)),
              PopupMenuButton<String>(
                icon: const Icon(Icons.analytics_sharp),
                onSelected: (String result) {
                  controller.sort(result);
                  // Handle the option selection
                },
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "name",
                    child: Text('Name'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'modified',
                    child: Text('Modified'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'size',
                    child: Text('Size'),
                  ),
                ],
              ),
            ],
            // bottom: PreferredSize(child: child, preferredSize: preferredSize),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Obx(() {
                return Listitem(documentviewed: controller.documentviewed,
                  primarycolour: controller.primarycolour,
                  documenttype: controller.documenttype,
                  updated: controller.updated,);
              }),
            ),
          ),
          // bottomNavigationBar: Obx(() {
          //   return BottomNavigationBar(items: const [
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.file_present), label: "Document"),
          //     BottomNavigationBarItem(icon: Icon(Icons.history), label: "Recent"),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.bookmark_sharp), label: "Favorite"),
          //   ],
          //     selectedItemColor: controller.primarycolour,
          //     unselectedItemColor: Colors.black,
          //     currentIndex: controller.currentindex,
          //     onTap: (i) {
          //       print(i);
          //       controller.currentindex = i;
          //     },
          //   );
          // }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => controller.pickFiles(),
            backgroundColor: controller.primarycolour,
            mini: true,
            child: const Icon(Icons.add, size: 40,),
          ),
        );
      }),
    );
  }

}
