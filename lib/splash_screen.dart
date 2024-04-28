import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempapp/appManager/localstorage_manager.dart';

import '../../navigation.dart';
import 'appManager/view_manager.dart';

///หน้าจอแสดงรูปของแอพ
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 16, right: 16),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 24),
              child: Image.asset(
                'assets/images/image_splash_logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.fitHeight,
              ),
            ),
            Text(
              'Temperature Application'.tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSizeManager().defaultSize),
            )
          ],
        ),
      ),
    );
  }

  checkLogin() {
    Timer(const Duration(seconds: 2), () async {
      await LocalStorageManager.getAccount().then((value) {
        if (value.auth != null) {
          Navigation.shared.toMainPage(context);
        } else {
          Navigation.shared.toLoginPage(context);
        }
      });
    });
  }
}
