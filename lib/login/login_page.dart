import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tempapp/appManager/localstorage_manager.dart';
import 'package:tempapp/model/user_model.dart';
import 'package:tempapp/widget/loading_btn.dart';

import '../appManager/dialog_manager.dart';
import '../appManager/view_manager.dart';
import '../model/login_model.dart';
import '../navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerEmailTextField = TextEditingController();
  TextEditingController _controllerPasswordTextField = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isRounded = false;
  bool loadingBtn = false;
  LoginDataModel loginData = LoginDataModel();
  UserModel userDataValid = UserModel();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      loadingBtn = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerEmailTextField.text.trim(),
        password: _controllerPasswordTextField.text.trim(),
      );

      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        setState(() {
          loadingBtn = false;
        });
        _showAlertDialogError("การยืนยันอีเมล", "กรุณายืนยันอีเมลของคุณก่อนเข้าสู่ระบบ");
        return;
      }

      String uid = userCredential.user!.uid;
      userDataValid.auth = uid;

      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userData.data() != null) {
        Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
        userDataMap.forEach((key, value) {
          if (key == "username") {
            userDataValid.userName = value;
          } else if (key == "email") {
            userDataValid.email = value;
          } else if (key == "phoneNo") {
            userDataValid.phoneNo = value;
          } else if (key == "profile") {
            userDataValid.profile = value;
          }
          LocalStorageManager.saveLoginData(userDataValid);
          Navigation.shared.toMainPage(context);
        });
      }
      print('User Data: ${userData.data()}');
      setState(() {
        loadingBtn = false;
      });
    } catch (e) {
      setState(() {
        loadingBtn = false;
      });

      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'รูปแบบอีเมลไม่ถูกต้อง';
            break;
          case 'user-not-found':
            errorMessage = 'ยังไม่มีบัญชี กรุณาลงทะเบียน';
            break;
          case 'wrong-password':
            errorMessage = 'รหัสผ่านไม่ถูกต้อง';
            break;
          case 'user-disabled':
            errorMessage = 'บัญชีผู้ใช้ถูกปิดใช้งาน';
            break;
          case 'too-many-requests':
            errorMessage = 'มีการพยายามเข้าสู่ระบบมากเกินไป กรุณาลองใหม่ภายหลัง';
            break;
          case 'operation-not-allowed':
            errorMessage = 'การเข้าสู่ระบบด้วยวิธีนี้ถูกปิดใช้งาน';
            break;
          case 'invalid-credential':
            errorMessage = 'ข้อมูลการยืนยันตัวตนไม่ถูกต้องหรือหมดอายุ';
            break;
          default:
            errorMessage = 'เกิดข้อผิดพลาด: ${e.message}';
            break;
        }
      } else {
        errorMessage = 'เกิดข้อผิดพลาด: ${e.toString()}';
      }

      _showAlertDialogError("เกิดข้อผิดพลาด", errorMessage);
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        left: false,
        top: true,
        right: false,
        bottom: true,
        child: Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 56),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 40),
                          child: Image.asset(
                            'assets/images/image_splash_logo.png',
                            width: 100,
                            height: 100,
                          )),
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              _usernameTextField(),
                              _passwordTextField(),
                              _btnLogin()
                            ],
                          ))
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('คุณไม่มีบัญชีใช่หรือไม่?'),
                    TextButton(
                        onPressed: () {
                          Navigation.shared.toRegister(context);
                        },
                        child: Text('ลงทะเบียน'))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameTextField() {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "อีเมล",
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
                  key: Key('email'),
                  controller: _controllerEmailTextField,
                  focusNode: usernameFocusNode,
                  validator: doubleFieldValidator.validate,
                  style: TextStyle(
                    fontSize: FontSizeManager().textLSize,
                  ),
                  cursorColor: ColorManager().primaryColor,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: ColorManager().primaryColor,
                    ),
                    fillColor: ColorManager().primaryColor.withOpacity(0.05),
                    filled: true,
                    hintText: "ระบุอีเมล",
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

  Widget _passwordTextField() {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              "รหัสผ่าน",
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
                  key: Key('password'),
                  controller: _controllerPasswordTextField,
                  focusNode: passwordFocusNode,
                  validator: doubleFieldValidator.validate,
                  obscureText: !isRounded,
                  style: TextStyle(
                    fontSize: FontSizeManager().textLSize,
                  ),
                  cursorColor: ColorManager().primaryColor,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: ColorManager().primaryColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isRounded
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 27,
                      ),
                      color: ColorManager().primaryColor,
                      onPressed: () {
                        setState(() {
                          isRounded = !isRounded;
                        });
                      },
                    ),
                    fillColor: ColorManager().primaryColor.withOpacity(0.05),
                    filled: true,
                    hintText: "ระบุรหัสผ่าน",
                    contentPadding: EdgeInsets.all(16),
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

  Widget _btnLogin() {
    return loadingBtn
        ? ButtonLoading()
        : Container(
            margin: EdgeInsets.only(top: 16),
            child: Material(
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      usernameFocusNode.unfocus();
                      passwordFocusNode.unfocus();
                      _signInWithEmailAndPassword();
                    }
                  });
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
                        "เข้าสู่ระบบ",
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

  showDialogInvalid() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return DialogSuccess(
            title: 'ข้อมูลไม่ถูกต้อง',
            icon: Icon(
              Icons.close,
              size: 50,
              color: ColorManager().primaryColor,
            ),
            content: 'กรุณากรอกใหม่',
            styleConfirm: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                elevation: 0,
                backgroundColor: ColorManager().primaryColor,
                padding: EdgeInsets.all(16)),
            textConfirmBtn: 'ตกลง',
            textStyleConfirm: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: FontSizeManager().defaultSize,
                color: Colors.white),
            sizeContent: 0,
            onPress: () {
              Navigator.pop(context);
            },
          );
        });
  }

  _showAlertDialogError(String title, String content) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("ตกลง"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class doubleFieldValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกข้อมูล";
    } else {
      return null;
    }
  }
}
