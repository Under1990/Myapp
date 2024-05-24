import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempapp/appManager/localstorage_manager.dart';
import 'package:tempapp/appManager/time_manager.dart';
import 'package:tempapp/model/noti_model.dart';
import 'package:tempapp/model/sensor1_model.dart';
import 'package:tempapp/model/sensor2_model.dart';

import '../NotificationManager.dart';
import '../main.dart';

class RealtimeDatabase {
  static String VALUETEMP = "";
  static String VALUELOGINDATA = "";
  static FirebaseDatabase realTimeDataBaseDomain = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://tempdashboard-5d96a-default-rtdb.firebaseio.com/');
  static StreamSubscription<DatabaseEvent>? refDataTemp1;
  static StreamSubscription<DatabaseEvent>? refDataTemp2;

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

static dataTempSensorOnChildChanged() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  realTimeDataBaseDomain.ref('data/data').onChildChanged.listen((event) async {
    // แก้ไขค่าตั้งต้นเป็นค่าว่าง
    String? maxTempSensor1Str = prefs.getString('MAXVALUETEMP1');
    String? minTempSensor1Str = prefs.getString('MINVALUETEMP1');
    String? maxTempSensor2Str = prefs.getString('MAXVALUETEMP2');
    String? minTempSensor2Str = prefs.getString('MINVALUETEMP2');

    if (event.snapshot.key == "sensor1") {
      // ตรวจสอบค่าที่ตั้งไว้ก่อนแปลงเป็น int
      if (maxTempSensor1Str == null || minTempSensor1Str == null) {
        print('Error: Temperature thresholds for sensor1 are not set.');
        return;
      }
      int maxTempSensor1 = int.parse(maxTempSensor1Str);
      int minTempSensor1 = int.parse(minTempSensor1Str);
      int dataOnValue1 = int.parse(event.snapshot.value.toString());
      await checkTemperatureNotification(dataOnValue1, maxTempSensor1, minTempSensor1, "sensor1", "Refrigerator 1");
    } else if (event.snapshot.key == "sensor2") {
      // ตรวจสอบค่าที่ตั้งไว้ก่อนแปลงเป็น int
      if (maxTempSensor2Str == null || minTempSensor2Str == null) {
        print('Error: Temperature thresholds for sensor2 are not set.');
        return;
      }
      int maxTempSensor2 = int.parse(maxTempSensor2Str);
      int minTempSensor2 = int.parse(minTempSensor2Str);
      int dataOnValue2 = int.parse(event.snapshot.value.toString());
      await checkTemperatureNotification(dataOnValue2, maxTempSensor2, minTempSensor2, "sensor2", "Refrigerator 2");
    }
  });
}


  static Future<void> checkTemperatureNotification(int dataOnValue, int maxTemp, int minTemp, String sensorKey, String sensorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();

    String lastHighTempKey = '${sensorKey}_last_high_temp';
    String lastLowTempKey = '${sensorKey}_last_low_temp';

    DateTime? lastHighTempNotification = prefs.containsKey(lastHighTempKey)
        ? DateTime.parse(prefs.getString(lastHighTempKey)!)
        : null;
    DateTime? lastLowTempNotification = prefs.containsKey(lastLowTempKey)
        ? DateTime.parse(prefs.getString(lastLowTempKey)!)
        : null;

    if (dataOnValue > maxTemp) {
      NotiModel dataNoti = NotiModel(
        title: "แจ้งเตือนอุณหภูมิ $sensorName",
        description:
            "อุณหภูมิสูง\nค่าที่ตั้งไว้: $maxTemp °C\nอุณหภูมิขณะนี้: $dataOnValue °C",
        dateInput: TimeManager.timeTriggerValue,
      );
      await LocalStorageManager.saveNotiData(dataNoti);
      NotificationManager.showNotification(dataNoti.title!, dataNoti.description!);
      _showAlertDialogError(
          'อุณหภูมิสูง $sensorName',
          "ค่าที่ตั้งไว้: $maxTemp °C\nอุณหภูมิขณะนี้: $dataOnValue °C",
          CupertinoColors.systemRed);
      prefs.setString(lastHighTempKey, now.toIso8601String());
    } else if (dataOnValue < minTemp) {
      NotiModel dataNoti = NotiModel(
        title: "แจ้งเตือนอุณหภูมิ $sensorName",
        description:
            "อุณหภูมิต่ำ\nค่าที่ตั้งไว้: $minTemp °C\nอุณหภูมิขณะนี้: $dataOnValue °C",
        dateInput: TimeManager.timeTriggerValue,
      );
      await LocalStorageManager.saveNotiData(dataNoti);
      NotificationManager.showNotification(dataNoti.title!, dataNoti.description!);
      _showAlertDialogError(
          'อุณหภูมิต่ำ $sensorName',
          "ค่าที่ตั้งไว้: $minTemp °C\nอุณหภูมิขณะนี้: $dataOnValue °C",
          CupertinoColors.systemYellow);
      prefs.setString(lastLowTempKey, now.toIso8601String());
    }
  }

  static _showAlertDialogError(String title, String content, Color bgColor) {
    showCupertinoModalPopup(
      context: GlobalVariable.navState.currentContext!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Container(
          color: bgColor,
          padding: EdgeInsets.all(10),
          child: Text(
            title,
            style: TextStyle(color: CupertinoColors.white),
          ),
        ),
        content: Container(
          color: bgColor,
          padding: EdgeInsets.all(10),
          child: Text(
            content,
            style: TextStyle(color: CupertinoColors.white),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              "ตกลง",
              style: TextStyle(color: CupertinoColors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
