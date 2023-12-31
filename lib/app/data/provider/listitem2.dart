import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'database.dart';
import 'datamodel.dart';

class Listitem2 extends StatelessWidget {
  final document;
  final primarycolour;
  final documenttype;
  final updated;

  const Listitem2({Key? key, required this.document,
    required this.primarycolour, required this.documenttype, required this.updated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // _onShare method:
    final box = context.findRenderObject() as RenderBox?;
    return ListTile(
              onTap: () {
                openfile(document.path);
              },
              leading: Image.asset("asset/pdf.png", width: 32.57, height: 38,),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                        document.favourite == 0 ? Icons.star_border : Icons
                            .star),
                    onPressed: () async {
                      if (document.favourite == 0) {
                        document.favourite = 1;
                      } else {
                        document.favourite = 0;
                      }
                      await updateContact(document);
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        bottomsheet(document, box);
                      },
                      icon: const Icon(Icons.more_vert)
                  ),
                ],
              ),
              title: Text(document.name),
              subtitle: FittedBox(
                child: Row(children: [
                  Text(document.datecreated),
                  const SizedBox(width: 30,),
                  Text(document.filesized)
                ],),
              ),
            );
  }

  void bottomsheet(Datamodel document, box) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset("asset/pdf.png", width: 32.57, height: 38,),
                const SizedBox(width: 20,),
                Expanded(
                  child: Text(document.name,
                    overflow: TextOverflow.clip,
                  ),
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 20,),
            ListTile(
              onTap: () {
                openfile(document.path);
                Get.back();
              },
              leading: Icon(Icons.file_open, color: primarycolour,),
              title: const Text("Open File"),
            ),
            ListTile(
              onTap: () {
                String? encodeQueryParameters(Map<String, String> params) {
                  return params.entries
                      .map((MapEntry<String, String> e) =>
                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(
                      e.value)}')
                      .join('&');
                }
// ···
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'smith@example.com',
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'Pdfreader',
                    'body': "I saw ${document
                        .name} interesting, that is why i'm sharing this with you",
                  }),
                );

                launchUrl(emailLaunchUri);

                Get.back();
              },
              leading: Icon(Icons.email, color: primarycolour,),
              title: const Text("Email"),
            ),
            ListTile(
              onTap: () async {
                await Share.shareXFiles(
                  [document.path],
                  text: "I saw ${document
                      .name} interesting, that is why i'm sharing this with you",
                  subject: "Pdfreader",
                  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box
                      .size,
                );
                Get.back();
              },
              leading: Icon(Icons.share, color: primarycolour,),
              title: const Text("Share"),
            ),
            ListTile(
              onTap: () async {
                Get.back();
                // await updateContact(document);
              },
              leading: Icon(Icons.edit, color: primarycolour,),
              title: const Text("Rename"),
            ),
            ListTile(
              onTap: () async {
                updated(document);
                Get.back();
              },
              leading: Icon(Icons.delete, color: primarycolour,),
              title: const Text("Delete"),
            ),
            const SizedBox(height: 20,),

          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  openfile(String path) {
    Get.toNamed("/viewpage", arguments: {"document": path});
  }
}
