import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfreader/app/modules/search_module/search_controller.dart';

import '../../data/provider/listitem.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class searchPage extends GetView<searchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search'),
        backgroundColor: controller.primarycolour,
      ),
      body: Container(
        child: Obx(()=>Container(
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
          Expanded(child: Listitem(documentviewed: controller.documentviewed,
            primarycolour: controller.primarycolour, documenttype: controller.documenttype,))
        ],
        ),)),
      ),
    );
  }
}
