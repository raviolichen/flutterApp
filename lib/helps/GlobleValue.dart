import 'package:flutter/cupertino.dart';

class GlobleValue extends InheritedWidget {
  static int userId;
  static String deviceId;
  static String token;
  static String userName;
  static String Golds;

  static const ServerIp = "http://192.168.5.26:8081/api/";

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


  @override
  bool updateShouldNotify(GlobleValue old) {
    return old.key != key;
  }
}
