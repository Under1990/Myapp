import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appManager/dialog_manager.dart';
import '../appManager/view_manager.dart';
import '../navigation.dart';

class SettingMaxTempPage extends StatefulWidget {
  final bool isDashBoard;
  final String refrig;

  const SettingMaxTempPage(
      {Key? key, required this.isDashBoard, required this.refrig})
      : super(key: key);

  @override
  State<SettingMaxTempPage> createState() => _SettingMaxTempPageState();
}

class _SettingMaxTempPageState extends State<SettingMaxTempPage> {
  TextEditingController _controllerSetTemp1TextField = TextEditingController();
  FocusNode setTemp1FocusNode = FocusNode();
  TextEditingController _controllerSetTemp2TextField = TextEditingController();
  FocusNode setTemp2FocusNode = FocusNode();

  @override
  void initState() {
    getMaxTempData();
    super.initState();
  }

  ///เก็บข้อมูลอุณหภูมิเมื่อตั้งค่าสูงสุด
  getMaxTempData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _controllerSetTemp1TextField.text = prefs.getString('MAXVALUETEMP1') ?? "";
    _controllerSetTemp2TextField.text = prefs.getString('MAXVALUETEMP2') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return widget.isDashBoard
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            body: _setFormDashBoard())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: ColorManager().primaryColor,
              // 1
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,)),
              titleSpacing: 0.0,
              title: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  // textAlign: TextAlign.center,
                  'ตั้งค่าสูงสุดของการแจ้งเตือนอุณหภูมิ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18),
                ),
              ),
            ),
            body: GestureDetector(
              onTap: () {
                print('tabbbbb');
                setTemp1FocusNode.unfocus();
                setTemp2FocusNode.unfocus();
              },
              child: SafeArea(
                child: Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(top: 32, left: 16, right: 16),
                  child: Column(
                    children: [
                      _setTemp1TextField(),
                      _setTemp2TextField(),
                      _btnSave()
                    ],
                  ),
                ),
              ),
            ),
          );
  }


  Widget _setFormDashBoard() {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Column(
        children: [
          Visibility(
              visible: widget.refrig == "sensor1", child: _setTemp1TextField()),
          Visibility(
              visible: widget.refrig != "sensor1", child: _setTemp2TextField()),
          _btnSave()
        ],
      ),
    );
  }

  Widget _setTemp1TextField() {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "ตั้งค่าสูงสุดของ Refrigerator 1",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: FontSizeManager().textLSize,
                  color: ColorManager().textColor),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: Key('temp1'),
                  keyboardType: TextInputType.number,
                  controller: _controllerSetTemp1TextField,
                  focusNode: setTemp1FocusNode,
                  style: TextStyle(
                    fontSize: FontSizeManager().textLSize,
                  ),
                  cursorColor: ColorManager().primaryColor,
                  textAlign: TextAlign.start,
                  // validator: doubleFieldValidator.validate,
                  decoration: InputDecoration(
                    prefixIcon: Image.asset(
                      'assets/icons/icon_temp.png',
                      scale: 15,
                      color: ColorManager().primaryColor,
                    ),
                    fillColor: ColorManager().primaryColor.withOpacity(0.05),
                    filled: true,
                    hintText: "กรุณาระบุอุณหภูมิสูงสุดที่ต้องการ",
                    contentPadding: EdgeInsets.all(16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                          color: ColorManager().primaryColor, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                          color: ColorManager().lineSeparate, width: 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _setTemp2TextField() {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "ตั้งค่าสูงสุดของ Refrigerator 2",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: FontSizeManager().textLSize,
                  color: ColorManager().textColor),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  key: Key('temp2'),
                  controller: _controllerSetTemp2TextField,
                  focusNode: setTemp2FocusNode,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: FontSizeManager().textLSize,
                  ),
                  cursorColor: ColorManager().primaryColor,
                  textAlign: TextAlign.start,
                  // validator: doubleFieldValidator.validate,
                  decoration: InputDecoration(
                    prefixIcon: Image.asset(
                      'assets/icons/icon_temp.png',
                      scale: 15,
                      color: ColorManager().primaryColor,
                    ),
                    fillColor: ColorManager().primaryColor.withOpacity(0.05),
                    filled: true,
                    hintText: "กรุณาระบุอุณหภูมิสูงสุดที่ต้องการ",
                    contentPadding: EdgeInsets.all(16),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                          color: ColorManager().primaryColor, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                          color: ColorManager().lineSeparate, width: 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ///ปุ่มการ save อุณหภูมิ
  Widget _btnSave() {
    return Container(
      margin: EdgeInsets.only(top: 32, left: 48, right: 48),
      child: Material(
        child: InkWell(
          onTap: () async {
            ///ตรวจสอบว่ามีการกรอกค่าเดิมหรือไม่
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (widget.isDashBoard) {
              if (widget.refrig == "sensor1") {
                if (_controllerSetTemp1TextField.text ==
                    prefs.getString('MAXVALUETEMP1')) {
                  showDialogSuccess('กรุณาเปลี่ยนแปลงค่าที่กำหนด', false, true);
                } else if (_controllerSetTemp1TextField.text.isNotEmpty) {
                  await prefs.setString(
                      'MAXVALUETEMP1', _controllerSetTemp1TextField.text);
                  showDialogSuccess(
                      'บันทึกการกำหนดค่าสูงสุดของ Refrigerator 1 สำเร็จ',
                      false,
                      false);
                }
              } else {
                if (_controllerSetTemp2TextField.text ==
                    prefs.getString('MAXVALUETEMP2')) {
                  showDialogSuccess('กรุณาเปลี่ยนแปลงค่าที่กำหนด', false, true);
                } else {
                  await prefs.setString(
                      'MAXVALUETEMP2', _controllerSetTemp2TextField.text);
                  showDialogSuccess(
                      'บันทึกการกำหนดค่าสูงสุดของ Refrigerator 2 สำเร็จ',
                      false,
                      false);
                }
              }
            } else {
              if (_controllerSetTemp1TextField.text.isNotEmpty &&
                  _controllerSetTemp2TextField.text.isNotEmpty) {
                await prefs.setString(
                    'MAXVALUETEMP1', _controllerSetTemp1TextField.text);
                await prefs.setString(
                    'MAXVALUETEMP2', _controllerSetTemp2TextField.text);
                showDialogSuccess(
                    'บันทึกการกำหนดค่าสูงสุดของทั้งสอง Refrigerator สำเร็จ',
                    false,
                    false);
              } else if (_controllerSetTemp1TextField.text.isNotEmpty) {
                await prefs.setString(
                    'MAXVALUETEMP1', _controllerSetTemp1TextField.text);
                showDialogSuccess(
                    'บันทึกการกำหนดค่าสูงสุดของ Refrigerator 1 สำเร็จ',
                    false,
                    false);
              } else if (_controllerSetTemp2TextField.text.isNotEmpty) {
                await prefs.setString(
                    'MAXVALUETEMP2', _controllerSetTemp2TextField.text);
                showDialogSuccess(
                    'บันทึกการกำหนดค่าสูงสุดของ Refrigerator 2 สำเร็จ',
                    false,
                    false);
              } else {
                showDialogSuccess(
                    'กรุณาระบุค่าสูงสุดของ Refrigerator อย่างน้อย 1 ตัว',
                    true,
                    false);
              }
            }
          },
          child: Ink(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF31c5a3), Color(0xFFc0edcc)]),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Container(
              width: double.infinity,
              height: 60,
              child: Center(
                child: Text(
                  "บันทึก",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontSizeManager().defaultSize,
                      color: ColorManager().secondaryColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///แจ้งเตือนเมื่อสำเร็จ
  showDialogSuccess(String title, bool checkIsValue, bool checkChangeValue) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return DialogSuccess(
            title: title,
            icon: Icon(
              Icons.check,
              size: 50,
              color: ColorManager().primaryColor,
            ),
            content: '',
            styleConfirm: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                elevation: 0,
                backgroundColor: ColorManager().primaryColor,
                padding: EdgeInsets.all(16)),
            textConfirmBtn: 'เสร็จสิ้น',
            textStyleConfirm: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: FontSizeManager().defaultSize,
                color: Colors.white),
            sizeContent: 0,
            onPress: () {
              widget.isDashBoard || checkChangeValue
                  ? Navigator.pop(context)
                  : Navigation.shared.toMainPage(context);
            },
          );
        });
  }
}
