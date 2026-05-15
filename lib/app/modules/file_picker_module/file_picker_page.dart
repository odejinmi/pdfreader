import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader/app/data/provider/listitem.dart';
import 'package:pdfreader/app/modules/file_picker_module/file_picker_controller.dart';
import 'package:pdfreader/app/services/ad_service.dart';

/// GetX Template Generator - fb.com/htngu.99
class FilePickerPage extends GetView<FilePickerController> {
  const FilePickerPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('My Documents'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: controller.tabController,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: controller.primarycolour,
                labelColor: controller.primarycolour,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                tabs: const <Widget>[
                  Tab(text: "PDFs"),
                  Tab(text: "Word"),
                ],
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  AdService().showRewarded(() {
                    Get.snackbar("Reward Earned", "You've unlocked premium features for this session!");
                  });
                },
                icon: Icon(Icons.workspace_premium, color: Colors.amber[700])
            ),
            IconButton(onPressed: () {
              Get.toNamed("/search", arguments: {
                "document": controller.documentviewed,
                "primarycolour": controller.primarycolour,
                "documenttype": controller.documenttype
              });
            }, icon: const Icon(Icons.search_rounded)),
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort_rounded),
              onSelected: (String result) {
                controller.sort(result);
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Obx(() {
            return Listitem(
              documentviewed: controller.documentviewed,
              primarycolour: controller.primarycolour,
              documenttype: controller.documenttype,
              updated: controller.updated,
            );
          }),
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: AdService().getBannerAd(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => controller.pickFiles(),
          backgroundColor: controller.primarycolour,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text("Add File", style: TextStyle(color: Colors.white)),
        ),
      );
    });
  }

}
