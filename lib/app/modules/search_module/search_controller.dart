import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/provider/database.dart';
import '../../data/provider/datamodel.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class searchController extends GetxController{

  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final _documenttype = ''.obs;
  set documenttype(value) => _documenttype.value = value;
  get documenttype => _documenttype.value;

  final _textEditingController = TextEditingController().obs;
  set textEditingController(value) => _textEditingController.value = value;
  get textEditingController => _textEditingController.value;


  final _documentviewed = <Datamodel>[].obs;
  set documentviewed(value) => _documentviewed.value = value;
  get documentviewed => _documentviewed.value;

  final _documentfetch = <Datamodel>[].obs;
  set documentfetch(value) => _documentfetch.value = value;
  get documentfetch => _documentfetch.value;

  final _primarycolour = const Color(0xffFE1643).obs;
  set primarycolour(value) => _primarycolour.value=value;
  get primarycolour => _primarycolour.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    documentfetch = Get.arguments["document"];
    primarycolour = Get.arguments["primarycolour"];
    documenttype = Get.arguments["documenttype"];
    fetch("");
  }
  fetch(String name){
    if (name.isEmpty) {
      _handleList(documentfetch);
    } else {
      var list = documentfetch.where((v) {
        return v.name.toString().toLowerCase().contains(name.toLowerCase());
      }).toList();
      _handleList(list);
    }
  }
  void _handleList(List<Datamodel> list) {
    documentviewed.clear();
    documentviewed.addAll(list);
  }

  updated(document) async {
    await deleteContact(document);
    documentviewed.remove(document);
  }
}
