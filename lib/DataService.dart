import 'helps/globlefun.dart';
import 'modules/DetailItem.dart';
import 'modules/DetailListItem.dart';
import 'modules/HomePageJson.dart';
import 'modules/RecordList.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'modules/FeildItemList.dart';
import 'modules/TypeItemList.dart';
import 'modules/detailEventitem.dart';
import 'helps/GlobleValue.dart';
import 'dart:convert' show  base64,utf8;

class RecordDataService {
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
class UserDataService{
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
class QRcodeDataService{
  Future< Map<String, dynamic> > postQrcodeValue(int userId, String token, String data)async  {
    //check userId
    if(userId==null||token==null){
      return json.decode("{\"result\":\"您尚未登入帳號，請確認網路狀態，或至會員頁面進行登入\"}");
    }
    String connectString = GlobleValue.QRcodePostAPI;
    Map postdata = {
      "userId":userId,
      "data":encydata(token,data),
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
class VoteItemDataService{
  Future<String> postVoteValue(String userId,String vId, String token, String data) async {
    String connectString = GlobleValue.PostVoteList;
    Map postdata = {
      "vId":vId,
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


}


class FeildItemDataService {
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

class DetailEventDataService {
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
class DetailDataService {
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
class HomePageJsonDataService {
  Future<String> _loadDetailAsset() async {
    return await _Get(GlobleValue.HomePageJsonAPI);
  }

  Future<HomePageData> loadDetail() async {
    String jsonString = await _loadDetailAsset();
    final jsonResponse = json.decode(jsonString);
    HomePageData homePageData = new HomePageData.fromJson(jsonResponse);
    return homePageData;
  }
}
class TypePageDataService {
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
class DetailListDataService {
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