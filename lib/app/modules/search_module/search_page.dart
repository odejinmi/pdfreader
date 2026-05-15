import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:pdfreader/app/data/provider/listitem2.dart';
import 'package:pdfreader/app/modules/search_module/search_controller.dart';
import 'package:pdfreader/app/services/ad_service.dart';

import '../../data/provider/datamodel.dart';

/// GetX Template Generator - fb.com/htngu.99
class SearchPage extends GetView<SearchController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Search Documents'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: controller.textEditingController,
              decoration: InputDecoration(
                hintText: 'Search by file name...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
                ),
              ),
              onChanged: controller.fetch,
            ),
          ),
          Expanded(
            child: Obx(() {
                return controller.documentviewed.isNotEmpty ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.documentviewed.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (BuildContext context, int index) {
                    Datamodel document = controller.documentviewed[index];
                    return Listitem2(
                      document: document,
                      primarycolour: controller.primarycolour,
                      documenttype: controller.documenttype,
                      updated: controller.updated,
                    );
                  }) : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[200]),
                      const SizedBox(height: 16),
                      Text(
                        "No results for '${controller.textEditingController.text}'",
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  );
              }
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SizedBox(
          height: 50,
          child: AdService().getBannerAd(),
        ),
      ),
    );
  }
}
