import 'package:localstorage/localstorage.dart';
import 'package:tempapp/model/login_model.dart';
import 'package:tempapp/model/noti_model.dart';
import 'package:tempapp/model/sensor1_model.dart';

import '../model/sensor2_model.dart';
import '../model/user_model.dart';

///การจัดการ local storage ของโทรศัพท์
class LocalStorageManager {
  static final LocalStorage storage = new LocalStorage('MyApp');

  static final String LOGINDATA = 'LOGINDATA';
  static final String SENSOR1 = 'SENSOR1';
  static final String SENSOR2 = 'SENSOR2';
  static final String NOTIDATA = 'NOTIDATA';

  static Future<UserModel> getAccount() async {
    await storage.ready;
    print('getDataData');
    var getApp = storage.getItem(LOGINDATA);
    if (getApp == null) {
      var response = UserModel();
      return response;
    }
    Map<String, dynamic> storageData = Map<String, dynamic>.from(getApp);
    var response = UserModel.fromJson(storageData);

    return response;
  }

  static Future<Sensor1DataModel> getDataSensor1() async {
    await storage.ready;
    print('getDataData');
    var getApp = storage.getItem(SENSOR1);
    if (getApp == null) {
      var response = Sensor1DataModel();
      return response;
    }
    Map<String, dynamic> storageData = Map<String, dynamic>.from(getApp);
    var response = Sensor1DataModel.fromJson(storageData);

    return response;
  }

  static Future<Sensor2DataModel> getDataSensor2() async {
    await storage.ready;
    print('getDataData');
    var getApp = storage.getItem(SENSOR2);
    if (getApp == null) {
      var response = Sensor2DataModel();
      return response;
    }
    Map<String, dynamic> storageData = Map<String, dynamic>.from(getApp);
    var response = Sensor2DataModel.fromJson(storageData);

    return response;
  }

  static Future<NotiModel> getNotiData() async {
    await storage.ready;
    print('getDataData');
    var getApp = storage.getItem(NOTIDATA);
    if (getApp == null) {
      return NotiModel();
    }
    Map<String, dynamic> storageData = Map<String, dynamic>.from(getApp);
    var response = NotiModel.fromJson(storageData);

    return response;
  }

  static saveNotiData(dynamic value) async {
    await storage.ready;
    return storage.setItem(NOTIDATA, value);
  }

  static saveDataSensor1(dynamic value) async {
    await storage.ready;
    return storage.setItem(SENSOR1, value);
  }

  static saveDataSensor2(dynamic value) async {
    await storage.ready;
    return storage.setItem(SENSOR2, value);
  }

  static saveLoginData(dynamic value) async {
    await storage.ready;
    print('saveChatData');
    return storage.setItem(LOGINDATA, value);
  }

  static Future<void> clearDataSensor1() async {
    await storage.ready;
    await storage.deleteItem(SENSOR1);
  }

  static Future<void> clearDataSensor2() async {
    await storage.ready;
    await storage.deleteItem(SENSOR2);
  }

  static void clearLoginData() async {
    print("clearLoginData");
    await storage.ready;
    await storage.deleteItem(LOGINDATA);
  }

  static void clearNotiData() async {
    print("clearLoginData");
    await storage.ready;
    await storage.deleteItem(NOTIDATA);
  }
}
