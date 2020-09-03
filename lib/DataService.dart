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
import 'modules/CacheDataModules.dart';
class RecordDataService {
  Future<String> _loadRecordsAsset(String Id, String RouterName,String md5) async {
    return await _Get(RouterName+"?Id="+Id+"&md5="+md5);
  }
  Future<RecordList> loadRecords(String Id, String RouterName) async {
    String cacheName=null;
    if(RouterName.compareTo(GlobleValue.StoreListGetAPI)==0)
      cacheName="StoreList?TypeId="+Id;
    List<cache> data=null;
    bool isCache=false;
    if(cacheName!=null) {
      await initCache();
      data = (await cacheHelp.caches(0, cacheName));
    }
    String jsonString = await _loadRecordsAsset(Id, RouterName,data!=null&&data.length>0?(data.first.LastEditDateTime??""):"");
    if(cacheName!=null&&jsonString.compareTo("cache")==0){
      jsonString=data.first.data;
      isCache=true;
    }
    final jsonResponse = json.decode(jsonString);
    RecordList records = new RecordList.fromJson(jsonResponse);
    if(cacheName!=null&&!isCache){
      if(data!=null&&data.length>0){
        cacheHelp.update(new cache(id: 0,data: jsonString,name: cacheName,LastEditDateTime:records.md5));
      }
      else{
        cacheHelp.insert(new cache(id: 0,data: jsonString,name: cacheName,LastEditDateTime: records.md5));
      }
    }
    return records;
  }
}
class UserDataService{
  Future<Map<String, dynamic>> getUserId(String deviceId,bool isOnlyUserData) async {
    String connectString = GlobleValue.UserGetIdAPI+"?deviceId="+deviceId+":"+isOnlyUserData.toString();
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
  Future< Map<String, dynamic> > postQrcodeValue(int userId, String token, String data,String proxydata)async  {
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
    if(proxydata!=null&&proxydata.length>0)
      postdata["proxy"]=proxydata;
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
class HomePageJsonDataService {
  Future<HomePageData> loadDetail() async {
    final GetData =await CacheData(0,GlobleValue.HomePageJsonAPI,"HomePageJson",'md5=',false);
    String jsonString=GetData['jsonString'];
    final jsonResponse = json.decode(jsonString);
    HomePageData homePageData = new HomePageData.fromJson(jsonResponse);
    if(!GetData['isCache'])
      SaveCache(new cache(id: 0,data: jsonString,name: 'HomePageJson',LastEditDateTime:homePageData.md5),GetData['data']!=null&&GetData['data'].length>0);
    return homePageData;
  }
}
class TypePageDataService {
  Future<TypeItemList> loadData() async {
    final GetData =await CacheData(0,GlobleValue.StoreTypeGetAPI,"StoreType",'md5=',false);
    String jsonString=GetData['jsonString'];
    final jsonResponse = json.decode(jsonString);
    TypeItemList typeItemList = new TypeItemList.fromJson(jsonResponse);
    if(!GetData['isCache'])
      SaveCache(new cache(id: 0,data: jsonString,name: 'StoreType',LastEditDateTime:typeItemList.md5),GetData['data']!=null&&GetData['data'].length>0);
    return typeItemList;
  }
}
class DetailEventDataService {
  Future<String> _loadDetailAsset(int eId,int userId,String LastEditDateTime) async {
    return await _Get(GlobleValue.EventitemAPI + '?eId=' + eId.toString() + '&userId='+userId.toString()+'&LastEditDateTime='+base64.encode(utf8.encode(LastEditDateTime)));
  }
  Future<DetailEventItem> loadDetail(int eId,int userId,String LastEditDateTime) async {
    String jsonString = await _loadDetailAsset(eId,userId, LastEditDateTime);
    final jsonResponse = json.decode(jsonString);
    DetailEventItem detailItem = new DetailEventItem.fromJson(jsonResponse);
    return detailItem;
  }
}
class DetailListDataService {
  Future<DetailListItem> loadDetail(String Id) async {
    int _Id=int.parse(Id);
    final GetData =await CacheData(_Id,GlobleValue.StoreDetailGetAPI,"store",'Id=' + Id+"&LastEditDateTime=",true);
    String jsonString=GetData['jsonString'];
    final jsonResponse = json.decode(jsonString);
    DetailListItem detailListItem = new DetailListItem.fromJson(jsonResponse);
    if(!GetData['isCache'])
      SaveCache(new cache(id: _Id,data: jsonString,name: 'store',LastEditDateTime:detailListItem.LastEditDateTime),GetData['data']!=null&&GetData['data'].length>0);
    return detailListItem;
  }
}
class DetailDataService {
  Future<DetailItem> loadDetail(String Id) async {
    int _Id=int.parse(Id);
    final GetData =await CacheData(_Id,GlobleValue.SlvDetailGetAPI,"Slvs",'Id=' + Id+"&LastEditDateTime=",true);
    String jsonString=GetData['jsonString'];
    final jsonResponse = json.decode(jsonString);
    DetailItem detailItem = new DetailItem.fromJson(jsonResponse);
    if(!GetData['isCache'])
      SaveCache(new cache(id: _Id,data: jsonString,name: 'Slvs',LastEditDateTime:detailItem.LastEditDateTime),GetData['data']!=null&&GetData['data'].length>0);
    return detailItem;
  }
}
Future<String> _loadDetailAsset(String APIName,String para) async {
  return await _Get( APIName + '?'+para);
}
Future<dynamic> CacheData(int Id,String APIName,String cacheName,String para,bool isNeedBase64LastEditDateTime) async{
  await initCache();
  String jsonString="";
  bool isCache=false;
  List<cache> data=(await cacheHelp.caches(Id, cacheName));
  jsonString = await _loadDetailAsset(APIName,para+ (isNeedBase64LastEditDateTime?base64.encode(utf8.encode(data!=null&&data.length>0?data.first.LastEditDateTime:"")):(data!=null&&data.length>0?data.first.LastEditDateTime:"")));
  if(jsonString.compareTo("cache")==0){
  jsonString=data.first.data;
  isCache=true;
  }
  return {'jsonString':jsonString,'isCache':isCache,'data':data};
}
void SaveCache(cache _cache,bool isExist){
  if(isExist){
    cacheHelp.update(_cache);
  }
  else{
    cacheHelp.insert(_cache);
  }
}
Future<String> _Get(String connect) async{
  try {
    http.Response response = await http.get(connect);
    if (response.statusCode == 200) {
      return response.body;
    } else
      return null;
  }
  catch(e){

    return null;
  }
}
