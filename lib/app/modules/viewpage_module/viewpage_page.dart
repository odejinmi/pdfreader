import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pdfreader/app/modules/viewpage_module/viewpage_controller.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ViewpagePage extends GetView<ViewpageController> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    // print("hello");
    final bool canJumpToPreviousPage = controller.pdfViewerController
        .pageCount > 1;
    final bool canJumpToNextPage =
        controller.pdfViewerController.pageNumber <
            controller.pdfViewerController.pageCount;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read pdf", style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: 20, child: controller.paginationTextField(context)),
              Padding(
                  padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    '/',
                    style: TextStyle(color: controller.color, fontSize: 16),
                    semanticsLabel: '',
                  )),
              Text(
                controller.pageCount.toString(),
                style: TextStyle(color: controller.color, fontSize: 16),
                semanticsLabel: '',
              )
              // Bookmark button
            ],
          ),
          // Previous page button
          // Padding(
          //   padding: const EdgeInsets.only(left: 16),
          //   child: Material(
          //       color: Colors.transparent,
          //       child: IconButton(
          //         icon: Icon(
          //           Icons.keyboard_arrow_up,
          //           color: canJumpToPreviousPage
          //               ? controller.color
          //               : controller.disabledColor,
          //           size: 24,
          //         ),
          //         onPressed: canJumpToPreviousPage
          //             ? () {
          //           // widget.onTap?.call('Previous page');
          //           controller.pdfViewerController.previousPage();
          //         }
          //             : null,
          //         tooltip: 'Previous page',
          //       )),
          // ),
          // // Next page button
          // Padding(
          //   padding: const EdgeInsets.only(left: 8),
          //   child: Material(
          //       color: Colors.transparent,
          //       child: IconButton(
          //         icon: Icon(
          //           Icons.keyboard_arrow_down,
          //           color: canJumpToNextPage
          //               ? controller.color
          //               : controller.disabledColor,
          //           size: 24,
          //         ),
          //         onPressed: canJumpToNextPage
          //             ? () {
          //           //widget.onTap?.call('Next page');
          //           controller.pdfViewerController.nextPage();
          //         }
          //             : null,
          //         tooltip: 'Next page',
          //       )),
          // ),

          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              controller.pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
          // Search button
          // Material(
          //   color: Colors.transparent,
          //   child: IconButton(
          //     icon: const Icon(
          //       Icons.search,
          //       color: Colors.white,
          //       size: 24,
          //     ),
          //     onPressed: () {
          //       _pdfViewerController.clearSelection();
          //       // widget.onTap?.call('Search');
          //     },
          //     tooltip: 'Search',
          //   ),
          // ),
          // // View settings button
          // Material(
          //   color: Colors.transparent,
          //   child: IconButton(
          //     icon: const Icon(
          //       Icons.settings,
          //       color: Colors.white,
          //       size: 24,
          //     ),
          //     onPressed:() {
          //       _pdfViewerController.clearSelection();
          //       // widget.onTap?.call('View settings');
          //     },
          //     tooltip: 'View settings' ,
          //   ),
          // ),
        ],
      ),
      body: SfPdfViewer.file(
        controller.file!,
        controller: controller.pdfViewerController,
        key: controller.pdfViewerKey,
        onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
          AlertDialog(
            title: Text(details.error),
            content: Text(details.description),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          var currentdocument = GetStorage().read("currentdocument");
          if (currentdocument != null) {
            // print(currentdocument);
            // print(int.parse(currentdocument));
            // controller.pdfViewerController.jumpToPage(int.parse(currentdocument));
          }
        },
        // pageLayoutMode: PdfPageLayoutMode.single,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          controller.speak();
        },
        child: Obx(() {
          return Icon(
            controller.ttsState == TtsState.stopped ? Icons.play_arrow : Icons
                .stop,
            color: controller.ttsState == TtsState.stopped ? Colors.green : Colors
                .red,);
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .miniCenterFloat,
    );
  }
}
