import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import 'alertdialog_permission.dart';

///การจัดการเกี่ยวกับการใช้รูปจากโทรศัพท์
class ImageManager {
  static Future<File> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return File("");

      final imageTemp = File(image.path);
      // return cropImage(imageTemp);
      return imageTemp;
    } on PlatformException catch (e) {
      var status = await Permission.storage.status;
      if (Platform.isIOS) {
        await showDialogPermission("You did not allow photo access", 'Cancel',
            'Setting', 'Allow to access photo on your device?');
      }
      return File("");
    }
  }

  static Future<File> pickCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return File("");

      final imageTemp = File(image.path);

      return imageTemp;
    } on PlatformException catch (e) {
      var status = await Permission.camera.status;
      if (Platform.isIOS) {
        await showDialogPermission("You did not allow camera access", 'Cancel',
            'Setting', 'Allow to access camera on your device?');
      }
      return File("");
    }
  }
}

showDialogPermission(
    String title, String textLeft, String textRight, String description) async {
  await showDialog(
    // barrierDismissible: true,
    context: GlobalVariable.navState.currentContext!,
    builder: (BuildContext context) => AlertDialogPermission(
      //"You did not allow photo access"
      title: title,
      mainContext: context,
      //'Cancel'
      textLeft: textLeft,
      //'Setting'
      textRight: textRight,
      callbackFunction: (answer) async {
        if (answer == false) {
          await openAppSettings();
          // Navigator.pop(context);
        }
      },
      description: description,
    ),
  );
}
