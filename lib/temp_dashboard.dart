import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tempapp/appManager/time_manager.dart';
import 'package:tempapp/settingmaxtemp/setting_maxtemp_page.dart';
import 'package:tempapp/test_gradient.dart';

import 'appManager/firebase_manager.dart';
import 'appManager/localstorage_manager.dart';
import 'appManager/view_manager.dart';


///หน้าแสดงผลการดูและการ set ค่าสูงสุดของอุณหภูมิ
class TempDashBoard extends StatefulWidget {
  final String type;
  final String dataSensor1;
  final String dataSensor2;
  final String date1;

  const TempDashBoard(
      {Key? key,
      required this.type,
      required this.dataSensor1,
      required this.dataSensor2,
      required this.date1})
      : super(key: key);

  @override
  State<TempDashBoard> createState() => _TempDashBoardState();
}

class _TempDashBoardState extends State<TempDashBoard> {
  String selectedTime = "60 นาที";
  List<DropdownMenuItem<String>> items = [
    '60 นาที',
    '24 ชั่วโมง',
    '7 วัน',
    '30 วัน'
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: TextStyle(color: Colors.black, fontSize: 14),
      ),
    );
  }).toList();

  FocusNode timeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    color: ColorManager().primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Temperature',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: widget.type == "sensor1"
                                    ? widget.dataSensor1
                                    : widget.dataSensor2,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 48)),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, -15),
                                child: Text(
                                  '\u2103',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textScaleFactor: 1.5,
                                ),
                              ),
                            )
                          ]),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 32),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  color: ColorManager().primaryColor.withOpacity(0.2),
                  child: Container(
                    padding: EdgeInsets.only(top: 32),
                    child: SettingMaxTempPage(
                      isDashBoard: true,
                      refrig: widget.type,
                    ),
                  ))
            ],
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Row(
                children: [
                  Container(
                      margin: EdgeInsets.only(right: 16),
                      child: Image.asset(
                        'assets/icons/icon_smile.png',
                        color: ColorManager().primaryColor,
                        width: 20,
                        height: 20,
                      )),
                  Text('Temperature Comfortable')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _timeDropDown() {
    return Container(
      margin: EdgeInsets.only(top: 32, right: 24),
      height: 100,
      width: 200,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          focusNode: timeFocusNode,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_outlined,
              color: ColorManager().primaryColor),
          style: TextStyle(
            fontSize: FontSizeManager().textLSize,
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide:
                  BorderSide(color: ColorManager().primaryColor, width: 1),
            ),
            fillColor: Colors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide:
                  BorderSide(color: ColorManager().primaryColor, width: 1),
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ]),
              height: 40,
              width: 40,
              child: Icon(
                Icons.calendar_month,
                size: 25,
                color: ColorManager().primaryColor,
              ),
            ),
          ),
          items: items,
          onChanged: (value) {
            setState(() {
              selectedTime = value.toString();
              if (value == "60 นาที") {
                TimeManager.reducedTimesSixty.clear();
                TimeManager.timeSixtyRange();
              } else if (value == "24 ชั่วโมง") {
                TimeManager.reducedTwentyHour.clear();
                TimeManager.timeTwentyHour();
              } else if (value == "7 วัน") {
                TimeManager.reducedSevenDays.clear();
                TimeManager.timeSevenDays();
              } else {
                TimeManager.reducedThirtyDays.clear();
                TimeManager.timeThirtyDays();
              }
              timeFocusNode.unfocus();
            });
          },
          hint: Text(
            "กรุณาเลือกวันที่",
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          value: selectedTime.isNotEmpty ? selectedTime : null,
        ),
      ),
    );
  }
}
