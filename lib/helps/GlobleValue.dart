import 'package:flutter/cupertino.dart';
class GlobleValue extends InheritedWidget {
  static int userId;
  static String deviceId;
  static String token;
  static String userName;
  static String Golds;
  static bool proxy;
  static String message_publish;
  static const proxycode="P0000000000000R0000000O0000000X0000000000000Y000";
  //static const ServerIp = "http://192.168.0.102:50780/api/";
  static const ServerIp = "http://app.chushang.gov.tw/api/";

//api Action
  static const HomePageJsonAPI = ServerIp + "_HomePage/GetHomePageJson";
  static const EventitemAPI = ServerIp + "eventitem/geteventdetail";
  static const EventitemSignFormAPI = ServerIp + "eventitem/GetEventSgin";
  static const EventitemSignPostAPI = ServerIp + "eventitem/PostSginData";
  static const UserGetIdAPI = ServerIp + "user/getUser";
  static const UserpostAPI = ServerIp + "user/postUser";
  static const StoreTypeGetAPI = ServerIp + "AboutStore/GetStoreType";
  static const StoreListGetAPI = ServerIp + "AboutStore/GetStoreList";
  static const StoreDetailGetAPI = ServerIp + "AboutStore/GetStoreDetail";
  static const QRcodePostAPI = ServerIp + "QRcode/PostQRCode";
  static const UserSlvGetAPI = ServerIp + "UserSlv/GetUserSlv";
  static const OwnerSlvGetAPI = ServerIp + "UserSlv/GetOwnerSlv";
  static const SlvDetailGetAPI = ServerIp + "UserSlv/GetSlvDetail";
  static const GetVoteList = ServerIp + "eventitem/GetVoteList";
  static const PostVoteList = ServerIp + "eventitem/PostVoteData";


  @override
  bool updateShouldNotify(GlobleValue old) {
    return old.key != key;
  }
}
