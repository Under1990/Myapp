import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempapp/appManager/localstorage_manager.dart';
import 'package:tempapp/main/setting_page.dart';

import '../appManager/firebase_manager.dart';
import '../appManager/time_manager.dart';
import '../appManager/view_manager.dart';
import '../model/noti_model.dart';
import '../navigation.dart';
import 'notification_page.dart';

class MainPageV2 extends StatefulWidget {
  const MainPageV2({Key? key}) : super(key: key);

  @override
  State<MainPageV2> createState() => _MainPageV2State();
}

class _MainPageV2State extends State<MainPageV2> {
  PersistentTabController _controllerTabBar = PersistentTabController();
  bool notSelect = false;
  String dataSensor1 = "";
  String dataSensor2 = "";
  String date1 = "";
  String date2 = "";
  String textAlert = "";
  String descriptionNoti = "";
  String date = "";

  @override
  void initState() {
    getData();
    onChangeData();
    _controllerTabBar = PersistentTabController(initialIndex: 1);
    _controllerTabBar.addListener(() {
      if (_controllerTabBar.index == 0 || _controllerTabBar.index != 1) {
        getDataNoti();
        setState(() {
          notSelect = true;
        });
      } else {
        setState(() {
          notSelect = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///แสดงข้อมูล noti ที่แจ้งเตือน
  getDataNoti() async {
    await LocalStorageManager.getNotiData().then((value) {
      setState(() {
        textAlert = value.title ?? "";
        descriptionNoti = value.description ?? "";
        date = value.dateInput ?? "";
      });
    });
  }

  ///แสดงข้อมูลอุณหภูมิ
  getData() async {
    await TimeManager.timeTrigger();
    await RealtimeDatabase.dataTemp().then((value) async => {
          await LocalStorageManager.getDataSensor1().then((value) {
            setState(() {
              dataSensor1 = value.tempData.toString();
              date1 = value.date ?? "";
            });
          }),
          await LocalStorageManager.getDataSensor2().then((value) {
            setState(() {
              dataSensor2 = value.tempData.toString();
              // date2 = value.date ?? "";
            });
          })
        });
    // await RealtimeDatabase.dataTemp();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String userPref = prefs.getString(RealtimeDatabase.VALUETEMP) ?? "";
    // Map<String, dynamic> tempData = jsonDecode(userPref);
    // tempData.forEach((key, value) {
    //   if (key == "sensor1") {
    //     dataSensor1 = value.toString();
    //   } else {
    //     dataSensor2 = value.toString();
    //   }
    // });
  }

  ///trigger เมื่ออุณหภูมิเปลี่ยนไปมากกว่าค่าที่กำหนด
  onChangeData() async {
    await RealtimeDatabase.dataTempSensorOnChildChanged();
  }

  @override
  Widget build(BuildContext context) {
    ///แสดงตัว tab bar
    return PersistentTabView(
      context,
      controller: _controllerTabBar,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }

  List<Widget> _buildScreens() {
    return [
      NotificationPage(
        textAlert: textAlert,
        descriptionNoti: descriptionNoti,
        date: date,
      ),
      Stack(
        children: [
          Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF31c5a3), Color(0xFFc0edcc)]),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 32),
                        height: 360,
                        child: Icon(
                          Icons.home_outlined,
                          size: 400,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                          top: 122,
                          left: 155,
                          child: Image.asset(
                            'assets/icons/icon_lamp.png',
                            width: 90,
                            height: 100,
                          )),
                      InkWell(
                        onTap: () {
                          Navigation.shared.toProfilePage(context);
                        },
                        child: Container(
                            margin: EdgeInsets.only(top: 32, right: 16),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Icon(
                              Icons.person,
                              color: ColorManager().primaryColor,
                            )),
                      )
                    ],
                  ),
                  Text(
                    'Refrigerator',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: 260),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      await getData();
                      Navigation.shared.toTempDashBoard(
                          context, "sensor1", dataSensor1, '', date1,);
                    },
                    child: Container(
                      height: 120,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/icon_temp.png',
                            width: 30,
                            height: 30,
                            color: ColorManager().primaryColor,
                          ),
                          Text(
                            'Refrigerator 1',
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorManager().primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await getData();
                      Navigation.shared.toTempDashBoard(
                          context, "sensor2", '', dataSensor2, '');
                    },
                    child: Container(
                      height: 120,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/icon_temp.png',
                            width: 30,
                            height: 30,
                            color: ColorManager().primaryColor,
                          ),
                          Text(
                            'Refrigerator 2',
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorManager().primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      SettingPage()
    ];
  }

  ///icon ของตัว tabbar
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.bell_fill),
        title: ("Notifications"),
        activeColorPrimary: ColorManager().primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          CupertinoIcons.home,
          color: Colors.white,
        ),
        title: ("Home"),
        activeColorPrimary: notSelect
            ? CupertinoColors.systemGrey
            : ColorManager().primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.settings),
        title: ("Settings"),
        activeColorPrimary: ColorManager().primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}
