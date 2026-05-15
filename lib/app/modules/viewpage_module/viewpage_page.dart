import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader/app/modules/viewpage_module/viewpage_controller.dart';
import 'package:pdfreader/app/services/ad_service.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ViewpagePage extends GetView<ViewpageController> {
  const ViewpagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        AdService().showInterstitial(
          onAdDismissed: () {
            Get.back();
          },
        );
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xff1E293B),
          elevation: 0,
          title: Text(
            controller.file?.path.split('/').last ?? "Reading",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_rounded)),
            IconButton(
                onPressed: () {
                  bottomsheet();
                },
                icon: const Icon(Icons.record_voice_over_rounded)
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.star_outline_rounded)
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_rounded)
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          clipBehavior: Clip.antiAlias,
          child: SfPdfViewer.file(
            controller.file!,
            controller: controller.pdfViewerController,
            key: controller.pdfViewerKey,
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              Get.defaultDialog(
                title: "Load Failed",
                middleText: details.description,
                textConfirm: "OK",
                onConfirm: () => Get.back(),
              );
            },
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                // controller.pdfViewerController.jumpToPage(int.parse(currentdocument));
            },
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 50,
                child: AdService().getBannerAd(),
              ),
            ],
          ),
        ),
        floatingActionButton: controller.playpause(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
;
  }
  void bottomsheet(){
    Get.bottomSheet(
      controller.voicecontroller(),
      backgroundColor: Colors.white,
    );
  }
}
