import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tempapp/appManager/localstorage_manager.dart';
import 'package:tempapp/model/user_model.dart';

import '../appManager/Image_manager.dart';
import '../appManager/view_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isPicture = false;
  bool loading = true;
  bool isNotEnable = false;
  bool isEditPicture = false;
  bool isEditPhone = false;
  bool isEditUsername = false;
  String imageProfile = "";
  UserModel userData = UserModel();
  TextEditingController _controllerPhoneNoTextField = TextEditingController();
  FocusNode phoneNoFocusNode = FocusNode();
  TextEditingController _controllerUsernameTextField = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  ///นำข้อมูล user มาแสดง
  getUserData() async {
    await LocalStorageManager.getAccount().then((value) {
      setState(() {
        userData.auth = value.auth;
        userData.userName = value.userName;
        userData.profile = value.profile;
        userData.phoneNo = value.phoneNo;
        userData.email = value.email;
        imageProfile = value.profile ?? "";
      });
    });
  }

  ///ตรวจสอบการพิมว่าไม่ใช่ค่าเก่า
  bool checkValueNotOld() {
    if (userData.userName == _controllerUsernameTextField.text ||
        userData.phoneNo == _controllerPhoneNoTextField.text) {
      setState(() {
        isNotEnable = true;
      });
      return isNotEnable;
    } else {
      setState(() {
        isNotEnable = false;
      });
      return isNotEnable;
    }
  }

  ///การอัพเดทข้อมูลลงใน firebase store
  Future<void> updateField() async {
    try {
      // Get reference to the document you want to update
      DocumentReference documentRef =
          FirebaseFirestore.instanceFor(app: Firebase.app())
              .collection('Users')
              .doc(userData.auth);

      // Update the specific field
      await documentRef.update({
        'username': _controllerUsernameTextField.text.isNotEmpty
            ? _controllerUsernameTextField.text
            : userData.userName,
        'phoneNo': _controllerPhoneNoTextField.text.isNotEmpty
            ? _controllerPhoneNoTextField.text
            : userData.phoneNo,
        'profile': imageProfile,
        // Replace 'field_to_update' wih the name of your field and 'new_value' with the new value
      });
      userData.userName = _controllerUsernameTextField.text.isNotEmpty
          ? _controllerUsernameTextField.text
          : userData.userName;
      userData.profile = imageProfile;
      userData.phoneNo = _controllerPhoneNoTextField.text.isNotEmpty
          ? _controllerPhoneNoTextField.text
          : userData.phoneNo;
      LocalStorageManager.saveLoginData(userData);
      getUserData();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print('Field updated successfully');
    } catch (e) {
      print('Error updating field: $e');
    }
  }

  static const snackBar = SnackBar(
    content: Text('อัพเดทโปรไฟล์สำเร็จ'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shadowColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'โปรไฟล์',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
          ),
          leading: BackButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              setState(() {
                Navigator.of(context).pop();
              });
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              usernameFocusNode.unfocus();
              phoneNoFocusNode.unfocus();
            });
          },
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showActionSheet(context);
                          });
                        },
                        child: _image(
                          context,
                          140,
                          "โปรไฟล์",
                        ),
                      ),
                      _menuView('ชื่อผู้ใช้งาน'),
                      Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            bottom: 24,
                            top: 16
                            // right: MediaQuery.of(context).size.width * 0.1
                            ),
                        child: isEditUsername
                            ? usernameFormField()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(
                                      Icons.person,
                                      size: 26.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('${userData.userName}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 16),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isEditUsername = true;
                                            _controllerUsernameTextField.text =
                                                userData.userName ?? "";
                                          });
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: ColorManager().primaryColor,
                                        )),
                                  )
                                ],
                              ),
                      ),
                      _lineVine(),
                      _menuView('อีเมล'),
                      Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            bottom: 32,
                            top: 16
                            // right: MediaQuery.of(context).size.width * 0.1
                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.email,
                                size: 26.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text('${userData.email}',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      _lineVine(),
                      _menuView('เบอร์โทรศัพท์'),
                      Container(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.1,
                            bottom: 16,
                            top: 16
                            // right: MediaQuery.of(context).size.width * 0.1
                            ),
                        child: isEditPhone
                            ? phoneNoFormField()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(
                                      Icons.phone,
                                      size: 26.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text('${userData.phoneNo}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 16),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isEditPhone = true;
                                            _controllerPhoneNoTextField.text =
                                                userData.phoneNo ?? "";
                                          });
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: ColorManager().primaryColor,
                                        )),
                                  )
                                ],
                              ),
                      ),
                      _lineVine(),
                    ],
                  ),
                ),
                Visibility(
                  visible: isEditUsername || isEditPhone || isEditPicture,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 48,
                          width: MediaQuery.of(context).size.width * 0.3,
                          margin: EdgeInsets.only(right: 16, left: 16),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isEditPhone = false;
                                isEditUsername = false;
                                isEditPicture = false;
                                if (imageProfile.isEmpty) {
                                  imageProfile = "";
                                }
                              });
                            },
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFFff0000),
                                  Color(0xFFf5a6a6)
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                child: Center(
                                  child: Text(
                                    "ยกเลิก",
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
                        Container(
                          height: 48,
                          width: MediaQuery.of(context).size.width * 0.4,
                          margin: EdgeInsets.only(right: 16, left: 16),
                          child: InkWell(
                            onTap: checkValueNotOld()
                                ? null
                                : () {
                                    updateField();
                                    setState(() {
                                      isEditPhone = false;
                                      isEditUsername = false;
                                      isEditPicture = false;
                                    });
                                  },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: checkValueNotOld()
                                    ? LinearGradient(colors: [
                                        Color(0xFF93979e),
                                        Color(0xFF93979e)
                                      ])
                                    : LinearGradient(colors: [
                                        Color(0xFF31c5a3),
                                        Color(0xFFc0edcc)
                                      ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget phoneNoFormField() {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              key: Key('phoneNo'),
              controller: _controllerPhoneNoTextField,
              focusNode: phoneNoFocusNode,
              keyboardType: TextInputType.number,
              maxLength: 10,
              validator: doubleFieldValidator.validatePhone,
              style: TextStyle(
                fontSize: FontSizeManager().textLSize,
              ),
              cursorColor: ColorManager().primaryColor,
              textAlign: TextAlign.start,
              // validator: doubleFieldValidator.validate,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: ColorManager().primaryColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _controllerPhoneNoTextField.text = "";
                    });
                  },
                  icon: Icon(Icons.close),
                ),
                fillColor: ColorManager().primaryColor.withOpacity(0.05),
                filled: true,
                hintText: "ระบุเบอร์โทรศัพท์",
                counterText: "",
                contentPadding: EdgeInsets.all(8),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      BorderSide(color: ColorManager().primaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      BorderSide(color: ColorManager().lineSeparate, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget usernameFormField() {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              key: Key('username'),
              controller: _controllerUsernameTextField,
              focusNode: usernameFocusNode,
              validator: doubleFieldValidator.validate,
              style: TextStyle(
                fontSize: FontSizeManager().textLSize,
              ),
              cursorColor: ColorManager().primaryColor,
              textAlign: TextAlign.start,
              // validator: doubleFieldValidator.validate,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                  color: ColorManager().primaryColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _controllerUsernameTextField.text = "";
                    });
                  },
                  icon: Icon(Icons.close),
                ),
                fillColor: ColorManager().primaryColor.withOpacity(0.05),
                filled: true,
                hintText: "ระบุชื่อผู้ใช้",
                contentPadding: EdgeInsets.all(8),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      BorderSide(color: ColorManager().primaryColor, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      BorderSide(color: ColorManager().lineSeparate, width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        child: CupertinoActionSheet(
          actions: <Widget>[
            Container(
              color: Colors.grey.shade50,
              child: CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await ImageManager.pickCamera().then((imageFile) => {
                          setState(() {
                            if (imageFile.path.isNotEmpty) {
                              imageProfile = imageFile.path;
                              print('imagePick ${imageProfile}');
                              isEditPicture = true;
                            }
                          }),
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 30,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        'เปิดกล้องถ่ายรูป',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.blueAccent),
                      )
                    ],
                  )),
            ),
            Container(
              color: Colors.grey.shade50,
              child: CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await ImageManager.pickImage().then((imageFile) => {
                          setState(() {
                            if (imageFile.path.isNotEmpty) {
                              imageProfile = imageFile.path;
                              isEditPicture = true;
                            }
                          }),
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Icon(
                          Icons.insert_photo_outlined,
                          size: 30,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        'เลือกรูปที่ต้องการ',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.blueAccent),
                      )
                    ],
                  )),
            ),
          ],
          cancelButton: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15)),
            child: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ยกเลิก',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red),
                )),
          ),
        ),
      ),
    );
  }

  Widget _image(context, double size, String roomPicture) {
    return Container(
      // color: Colors.red,
      height: size,
      width: size,
      child: Stack(
        children: [
          Positioned(
              child: Container(
            height: size * 0.95,
            width: size * 0.95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade100,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              radius: size * 0.60,
              backgroundColor: Colors.white,
              child: ClipOval(
                  child: Image.file(File('${imageProfile}'),
                      width: size, height: size, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                return CircleAvatar(
                  radius: size * 0.60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: size * 0.77,
                    color: Theme.of(context).primaryColor,
                  ),
                );
              }) /*!isPicture
                        ? Image.network(roomPicture,
                        width: size, height: size, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: size * 0.60,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.group,
                              size: size * 0.77,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        })
                        : Image.file(File('${profileImage?.path}'),
                        width: size, height: size, fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return CircleAvatar(
                            radius: size * 0.60,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.group,
                              size: size * 0.77,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        }),*/
                  ),
            ),
          )),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 1)]),
              child: ClipOval(
                child: CircleAvatar(
                  radius: size * 0.12,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.camera_alt,
                    size: size * 0.15,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _lineVine() {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.07,
          bottom: 16,
          right: MediaQuery.of(context).size.width * 0.07),
      height: 1,
      color: Colors.black,
    );
  }

  Widget _menuView(String str) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.07,
          bottom: 8,
          right: MediaQuery.of(context).size.width * 0.07),
      child: Text(str,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )),
    );
  }
}

///เช็ตการกรอกข้อมูล
class doubleFieldValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกข้อมูล";
    } else {
      return null;
    }
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกข้อมูล";
    } else if (value.length < 10) {
      return "กรุณากรอกตัวเลขให้ครบจำนวน";
    } else {
      return null;
    }
  }
}