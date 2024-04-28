import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempapp/appManager/firebase_manager.dart';
import 'package:tempapp/appManager/localstorage_manager.dart';

import '../appManager/view_manager.dart';
import '../navigation.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตั้งค่า',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Container(),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16, top: 48),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: ColorManager().primaryColor.withOpacity(0.8),
                )),
            InkWell(
              onTap: () {
                Navigation.shared.toProfilePage(context);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorManager().primaryColor.withOpacity(0.3)),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Icon(Icons.person)),
                            Text(
                              'ตั้งค่าบัญชี',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigation.shared.toSettingMaxTempPage(context);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorManager().primaryColor.withOpacity(0.3)),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(right: 8),
                                child: Image.asset(
                                  'assets/icons/icon_temp.png',
                                  width: 25,
                                  height: 25,
                                )),
                            Text(
                              'ตั้งค่าสูงสุดของการแจ้งเตือนอุณหภูมิ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _showConfirmLogout();
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorManager().primaryColor.withOpacity(0.3)),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Row(
                          children: [
                            Text(
                              'ออกจากระบบ',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.exit_to_app_outlined)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _showConfirmLogout() {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('ออกจากระบบ'),
        content: Text('ต้องการออกจากระบบหรือไม่ ?'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              LocalStorageManager.clearLoginData();
              LocalStorageManager.clearDataSensor1();
              LocalStorageManager.clearDataSensor2();
              LocalStorageManager.clearNotiData();
              RealtimeDatabase.refDataTemp1?.cancel();
              RealtimeDatabase.refDataTemp2?.cancel();
              prefs.clear();
              Navigation.shared.toLoginPage(context);
            },
          ),
        ],
      ),
    );
  }
}
