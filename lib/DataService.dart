import 'modules/DetailItem.dart';
import 'modules/DetailListItem.dart';
import 'modules/HomePageJson.dart';
import 'modules/RecordList.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'modules/FeildItemList.dart';
import 'modules/TypeItemList.dart';
import 'modules/detailEventitem.dart';
import 'helps/GlobleValue.dart';
import 'dart:convert' show  base64,utf8;
import 'package:encrypt/encrypt.dart';

class RecordService {
  Future<String> _loadRecordsAsset(String Id, String RouterName) async {
    return await _Get(RouterName+"?Id="+Id);
  }

  Future<RecordList> loadRecords(String Id, String RouterName) async {
    String jsonString = await _loadRecordsAsset(Id, RouterName);
    final jsonResponse = json.decode(jsonString);
    RecordList records = new RecordList.fromJson(jsonResponse);
    return records;
  }
}
class UserService{
  Future<Map<String, dynamic>> getUserId(String deviceId) async {
    String connectString = GlobleValue.UserGetIdAPI+"?deviceId="+deviceId;
    http.Response response = await http.get(connectString);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonmap=json.decode(response.body);
      return jsonmap;
    } else
      return null;
  }
  Future<Map<String, dynamic>> postUser(String data) async {
    String connectString = GlobleValue.UserpostAPI;
    http.Response response = await http.post(connectString,
        headers: {"Content-Type":"application/json"},
        body: json.encode(data));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonmap=json.decode(response.body);
      return jsonmap;
    } else
      return null;
  }
}
class QRcodeService{
  Future< Map<String, dynamic> > postQrcodeValue(int userId, String token, String data)async  {
    String connectString = GlobleValue.QRcodePostAPI;
    String Akey=token.substring(0,32);
    String iv=token.substring(32,48);
    final encrypter = Encrypter(AES( Key.fromUtf8(Akey),mode:AESMode.cbc,padding: 'PKCS7'));
    Map postdata = {
      "userId":userId,
      "data":encrypter.encrypt(data, iv: IV.fromUtf8(iv)).base64,
      "time":DateTime.now().toString()
    };
    http.Response response = await http.post(connectString,
        headers: {"Content-Type":"application/json"},
        body: "'"+json.encode(postdata)+"'");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else
      return null;
  }
}
class FeildItemService {
  Future<String> postEeildValue(int eId,String userId, String token, String data) async {
    String connectString = GlobleValue.EventitemSignPostAPI;
    Map postdata = {
      "eId":eId,
      "userId":userId,
      "token":token,
      "data":base64.encode(utf8.encode(data))
    };
    http.Response response = await http.post(connectString,
        headers: {"Content-Type":"application/json"},
        body: "'"+json.encode(postdata)+"'");
    if (response.statusCode == 200) {
      return response.body;
    } else
      return "";
  }
  Future<String> _loadFeildItemListAsset(int eId, int userId) async {
    return await _Get(GlobleValue.EventitemSignFormAPI +'?eId='+eId.toString() +'&userId='+userId.toString());
  }
  Future<FeildItemList> loadFeildItemList(int eId, int userId) async {
    String jsonString = await _loadFeildItemListAsset(eId, userId);
    final jsonResponse = json.decode(jsonString);
    FeildItemList feildItems = new FeildItemList.fromJson(jsonResponse);
    return feildItems;
  }
}
class DetailEventService {
  Future<String> _loadDetailAsset(int eId,int userId) async {
    return await _Get(   GlobleValue.EventitemAPI + '?eId=' + eId.toString() + '&userId='+userId.toString());
  }

  Future<DetailEventItem> loadDetail(int eId,int userId) async {
    String jsonString = await _loadDetailAsset(eId,userId);
    final jsonResponse = json.decode(jsonString);
    DetailEventItem detailItem = new DetailEventItem.fromJson(jsonResponse);
    return detailItem;
  }
}
class DetailService {
  Future<String> _loadDetailAsset(String Id) async {
    return await _Get( GlobleValue.SlvDetailGetAPI + '?Id=' + Id);
  }

  Future<DetailItem> loadDetail(String Id) async {
    String jsonString = await _loadDetailAsset(Id);
    final jsonResponse = json.decode(jsonString);
    DetailItem detailItem = new DetailItem.fromJson(jsonResponse);
    return detailItem;
  }
}
class HomePageJsonService {
  Future<String> _loadDetailAsset() async {
    return await _Get(GlobleValue.HomePageJsonAPI);
    String connectString = GlobleValue.HomePageJsonAPI;
    http.Response response = await http.get(connectString);
    if (response.statusCode == 200) {
      return response.body;
    } else
      return "";
    return await rootBundle.loadString('assets/data/HomePage.json');
  }

  Future<HomePageData> loadDetail() async {
    String jsonString = await _loadDetailAsset();
    final jsonResponse = json.decode(jsonString);
    HomePageData homePageData = new HomePageData.fromJson(jsonResponse);
    return homePageData;
  }
}
class TypePageService {
  Future<String> _loadDetailAsset() async {
    return await _Get(GlobleValue.StoreTypeGetAPI);
  }

  Future<TypeItemList> loadData() async {
    String jsonString = await _loadDetailAsset();
    final jsonResponse = json.decode(jsonString);
    TypeItemList typeItemList = new TypeItemList.fromJson(jsonResponse);
    return typeItemList;
  }
}
class DetailListService {
  Future<String> _loadDetailAsset(String Id) async {
    return await _Get(GlobleValue.StoreDetailGetAPI+"?Id="+Id);
  }

  Future<DetailListItem> loadDetail(String Id) async {
    String jsonString = await _loadDetailAsset(Id);
    final jsonResponse = json.decode(jsonString);
    DetailListItem detailListItem = new DetailListItem.fromJson(jsonResponse);
    return detailListItem;
  }
}
Future<String> _Get(String connect) async{
  http.Response response = await http.get(connect);
  if (response.statusCode == 200) {
    return response.body;
  } else
    return "";
}