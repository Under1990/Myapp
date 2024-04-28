import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tempapp/settingmaxtemp/setting_maxtemp_page.dart';
import 'package:tempapp/temp_dashboard.dart';

import 'login/login_page.dart';
import 'login/regsiter_page.dart';
import 'main/main_pageV2.dart';
import 'main/profile_page.dart';

///รวมการเชื่อมต่อไปหน้าต่างๆ
class Navigation {
  static Navigation shared = Navigation();

  void toLoginPage(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  void toMainPage(context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MainPageV2()));
  }

  void toTempDashBoard(
      context, String type, String sensor1, String sensor2, String date1) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TempDashBoard(
                  type: type,
                  dataSensor1: sensor1,
                  dataSensor2: sensor2,
                  date1: date1,
                )));
  }

  void toRegister(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));
  }

  void toSettingMaxTempPage(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingMaxTempPage(
                  isDashBoard: false,
                  refrig: '',
                )));
  }

  void toProfilePage(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }
}
