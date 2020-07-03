import 'package:demoApp/modules/TypeItemList.dart';
import 'package:demoApp/modules/detailitem.dart';

import 'modules/DetailListItem.dart';
import 'modules/HomePageJson.dart';
import 'modules/RecordList.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'modules/FeildItemList.dart';
import 'modules/detailitem.dart';

class RecordService {
  Future<String> _loadRecordsAsset(String Id,String RouterName) async {
    return await rootBundle.loadString('assets/data/'+RouterName+'.json');
  }
  Future<RecordList> loadRecords(String Id,String RouterName) async {
    String jsonString = await _loadRecordsAsset( Id, RouterName);
    final jsonResponse = json.decode(jsonString);
    RecordList records = new RecordList.fromJson(jsonResponse);
    return records;
  }
}
class FeildItemService {
  Future<String> _loadFeildItemListAsset(int userId) async {
    return await rootBundle.loadString('assets/data/feilditems.json');
  }

  Future<FeildItemList> loadFeildItemList(int userId) async {
    String jsonString = await _loadFeildItemListAsset(userId);
    final jsonResponse = json.decode(jsonString);
    FeildItemList feildItems = new FeildItemList.fromJson(jsonResponse);
    return feildItems;
  }
}
class DetailService {
  Future<String> _loadDetailAsset(int eId) async {
    return await rootBundle.loadString('assets/data/detail.json');
  }

  Future<DetailItem> loadDetail(int eId) async {
    String jsonString = await _loadDetailAsset(eId);
    final jsonResponse = json.decode(jsonString);
    DetailItem detailItem = new DetailItem.fromJson(jsonResponse);
    return detailItem;
  }
}
class HomePageJsonService{
  Future<String> _loadDetailAsset() async {
    return await rootBundle.loadString('assets/data/HomePage.json');
  }

  Future<HomePageData> loadDetail() async {
    String jsonString = await _loadDetailAsset();
    final jsonResponse = json.decode(jsonString);
    HomePageData homePageData = new HomePageData.fromJson(jsonResponse);
    return homePageData;
  }
}
class TypePageService{
  Future<String> _loadDetailAsset() async {
    return await rootBundle.loadString('assets/data/StoreType.json');
  }

  Future<TypeItemList> loadData() async {
    String jsonString = await _loadDetailAsset();
    final jsonResponse = json.decode(jsonString);
    TypeItemList typeItemList = new TypeItemList.fromJson(jsonResponse);
    return typeItemList;
  }
}
class DetailListService{
  Future<String> _loadDetailAsset(int eId) async {
    return await rootBundle.loadString('assets/data/storeDeatil.json');
  }
  Future<DetailListItem> loadDetail(int eId) async {
    String jsonString = await _loadDetailAsset(eId);
    final jsonResponse = json.decode(jsonString);
    DetailListItem detailListItem = new DetailListItem.fromJson(jsonResponse);
    return detailListItem;
  }
}
