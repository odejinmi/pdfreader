import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader/app/data/provider/listitem2.dart';
import 'package:pdfreader/app/modules/search_module/search_controller.dart';

import '../../data/provider/datamodel.dart';
import '../../data/provider/listitem.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class searchPage extends GetView<searchController> {
  const searchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'),
        backgroundColor: controller.primarycolour,
      ),
      body: Container(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                TextFormField(
                  controller: controller.textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Searching...',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Color(0xffD9D9D9))
                    ),
                    fillColor: Color(0xffD9D9D9),
                  ),
                  onChanged: controller.fetch,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                // Expanded(child: Obx(() {
                //   print("hello");
                //   return Listitem(documentviewed: controller.documentviewed,
                //     primarycolour: controller.primarycolour,
                //     documenttype: controller.documenttype,
                //     updated: controller.updated,);
                // }))
                Expanded(
                  child: Obx(() {
                      return controller.documentviewed.isNotEmpty ? ListView.builder(
                        itemCount: controller.documentviewed.length,
                        itemBuilder: (BuildContext context, int index) {
                        Datamodel document = controller.documentviewed[index];
                            return Listitem2(document: document,
                              primarycolour: controller.primarycolour,
                              documenttype: controller.documenttype,
                              updated: controller.updated,);
                        }) : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("asset/empty.png", height: 171, width: 171,),
                            Text("You don't have any ${controller.documenttype.toUpperCase()} document",
                              style: const TextStyle(color: Color(0xff868686),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),)
                          ],
                        );
                    }
                  ),
                ),
    ],
              ),),
    );
  }
}
