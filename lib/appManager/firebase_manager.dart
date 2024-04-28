import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempapp/appManager/localstorage_manager.dart';
import 'package:tempapp/appManager/time_manager.dart';
import 'package:tempapp/model/login_model.dart';
import 'package:tempapp/model/noti_model.dart';
import 'package:tempapp/model/sensor1_model.dart';

import '../main.dart';
import '../model/sensor2_model.dart';

class RealtimeDatabase {
  static String VALUETEMP = "";
  static String VALUELOGINDATA = "";

  static FirebaseDatabase realTimeDataBaseDomain = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://tempdashboard-5d96a-default-rtdb.firebaseio.com/');

  static StreamSubscription<DatabaseEvent>? refDataTemp1;

  static StreamSubscription<DatabaseEvent>? refDataTemp2;

  ///ดึงค่าจากการอ่าน realtime database
  static Future dataTemp() async {
    await realTimeDataBaseDomain
        .ref('data/data/sensor1')
        .get()
        .then((value) async {
      Sensor1DataModel data = Sensor1DataModel();
      data.tempData = value.value;
      data.date = TimeManager.timeTriggerValue;
      await LocalStorageManager.saveDataSensor1(data);
    });
    await realTimeDataBaseDomain
        .ref('data/data/sensor2')
        .get()
        .then((value) async {
      Sensor2DataModel data = Sensor2DataModel();
      data.tempData = value.value;
      await LocalStorageManager.saveDataSensor2(data);
    });
  }

  ///Trigger การแจ้งเตือนของ Refrig1
  static dataTempSensorOnChildChanged() async {
    int dataLocalToInt = 0;
    int dataLocalToInt2 = 0;
    int dataOnValue = 0;
    int dataOnValue2 = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    realTimeDataBaseDomain.ref('data/data/sensor1').get().then((value) {
      if (value.value != null) {
        refDataTemp1 = realTimeDataBaseDomain
            .ref('data/data/')
            .onChildChanged
            .listen((event) async {
          if (event.snapshot.key == "sensor1") {
            dataLocalToInt = int.parse(prefs.getString('MAXVALUETEMP1') ?? "");
            dataOnValue = int.parse(event.snapshot.value.toString());
            if (dataOnValue > dataLocalToInt) {
              NotiModel dataNoti = NotiModel();
              dataNoti.title = "แจ้งเตือนอุณหภูมิ Refrigerator 1";
              dataNoti.description =
                  "ค่าของอุณหภูมิเกินอุณหภูมิสูงสุดในปัจจุบันที่กำหนดไว้";
              dataNoti.dateInput = TimeManager.timeTriggerValue;
              LocalStorageManager.saveNotiData(dataNoti);
              _showAlertDialogError('แจ้งเตือนอุณหภูมิ Refrigerator 1',
                  'ค่าของอุณหภูมิเกินอุณหภูมิสูงสุดในปัจจุบันที่กำหนดไว้');
            }
          } else {
            dataLocalToInt = int.parse(prefs.getString('MAXVALUETEMP2') ?? "");
            dataOnValue2 = int.parse(event.snapshot.value.toString());
            if (dataOnValue2 > dataLocalToInt2) {
              NotiModel dataNoti = NotiModel();
              dataNoti.title = "แจ้งเตือนอุณหภูมิ Refrigerator 2";
              dataNoti.description =
                  "ค่าของอุณหภูมิเกินอุณหภูมิสูงสุดในปัจจุบันที่กำหนดไว้";
              dataNoti.dateInput = TimeManager.timeTriggerValue;
              LocalStorageManager.saveNotiData(dataNoti);
              _showAlertDialogError('แจ้งเตือนอุณหภูมิ Refrigerator 2',
                  'ค่าของอุณหภูมิเกินอุณหภูมิสูงสุดในปัจจุบันที่กำหนดไว้');
            }
          }

          // if (event.snapshot.value != value.value) {
          //   Sensor1DataModel data = Sensor1DataModel();
          //   data.tempData = event.snapshot.value;
          //   // data.date = jsonEncode({DateTime.now()});
          //   print('data ${data.toJson()}');
          //   await LocalStorageManager.saveDataSensor1(data);
          // }
        });
      }
    });
  }

  ///Trigger การแจ้งเตือนของ Refrig1
  static dataTempSensor2OnChildChanged() async {
    int dataLocalToInt = 0;
    int dataOnValue = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dataLocalToInt = int.parse(prefs.getString('MAXVALUETEMP2') ?? "");
    realTimeDataBaseDomain.ref('data/data/sensor2').get().then((value) {
      if (value.value != null) {
        refDataTemp2 = realTimeDataBaseDomain
            .ref('data/data/sensor2')
            .onValue
            .listen((event) async {
          dataOnValue = int.parse(event.snapshot.value.toString());
          if (dataOnValue > dataLocalToInt) {
            NotiModel dataNoti = NotiModel();
            dataNoti.title = "แจ้งเตือนอุณหภูมิ Refrigerator 2";
            dataNoti.description =
                "ค่าของอุณหภูมิเกินอุณหภูมิสูงสุดในปัจจุบันที่กำหนดไว้";
            dataNoti.dateInput = TimeManager.timeTriggerValue;
            LocalStorageManager.saveNotiData(dataNoti);
            _showAlertDialogError('แจ้งเตือนอุณหภูมิ Refrigerator 2',
                'ค่าของอุณหภูมิเกินอุณหภูมิสูงสุดในปัจจุบันที่กำหนดไว้');
          }
          // print('datasensor2 ${event.snapshot.value}');
          // if (event.snapshot.value != value.value) {
          //   Sensor2DataModel data = Sensor2DataModel();
          //   data.tempData = event.snapshot.value;
          //   data.date = DateTime.now();
          //   await LocalStorageManager.saveDataSensor2(event.snapshot.value);
          // }
        });
      }
    });
  }

  static _showAlertDialogError(String title, String content) {
    showCupertinoModalPopup(
      context: GlobalVariable.navState.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
      ),
    );
  }
}
