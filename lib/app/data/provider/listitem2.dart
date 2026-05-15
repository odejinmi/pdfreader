import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/ad_service.dart';
import 'database.dart';
import 'datamodel.dart';

class Listitem2 extends StatelessWidget {
  final Datamodel document;
  final Color primarycolour;
  final String documenttype;
  final Future<void> Function(Datamodel) updated;

  const Listitem2({
    super.key,
    required this.document,
    required this.primarycolour,
    required this.documenttype,
    required this.updated,
  });

  @override
  Widget build(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          openfile(document.path);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (document.type == 'pdf' ? Colors.red[50] : Colors.blue[50]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  document.type == 'pdf' ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
                  color: document.type == 'pdf' ? Colors.red[700] : Colors.blue[700],
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xff1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            document.datecreated,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          document.filesized,
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                    document.favourite == 0 ? Icons.star_outline_rounded : Icons.star_rounded,
                    color: document.favourite == 0 ? Colors.grey[400] : Colors.amber),
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
                  icon: Icon(Icons.more_vert_rounded, color: Colors.grey[600])
              ),
            ],
          ),
        ),
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
                await SharePlus.instance.share(
                  ShareParams(
                    files: [XFile(document.path)],
                    text: "I saw ${document.name} interesting, that is why i'm sharing this with you",
                    subject: "Pdfreader",
                    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                  ),
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
    AdService().showInterstitial(
      onAdDismissed: () {
        Get.toNamed("/viewpage", arguments: {"document": path});
      },
    );
  }
}
