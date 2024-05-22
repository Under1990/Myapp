import 'package:flutter/material.dart';
import 'package:tempapp/appManager/view_manager.dart';

///ไฟล์ตกแต่ง dialog
class DialogSuccess extends StatefulWidget {
  final String title;
  final Widget icon;
  final String content;
  final ButtonStyle styleConfirm;
  final String textConfirmBtn;
  final Function() onPress;
  final double sizeContent;
  final TextStyle textStyleConfirm;

  const DialogSuccess(
      {Key? key,
        required this.title,
        required this.icon,
        required this.content,
        required this.styleConfirm,
        required this.textConfirmBtn,
        required this.textStyleConfirm,
        required this.sizeContent, required this.onPress})
      : super(key: key);

  @override
  State<DialogSuccess> createState() => _DialogSuccessState();
}

class _DialogSuccessState extends State<DialogSuccess> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: widget.icon,
      title: Text(widget.title,style: TextStyle(color: ColorManager().textColor,fontSize: FontSizeManager().defaultSize),),
      titlePadding: EdgeInsets.only(top: 16),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Container(
        margin: EdgeInsets.only(left: 24,right: 24),
        height: widget.sizeContent,
        alignment: Alignment.center,
        child: Text(widget.content,textAlign: TextAlign.center,maxLines: 6,),
      ),
      contentPadding: EdgeInsets.only(top: 16, bottom: 8),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 8,right: 8,bottom: 24),
          child: ElevatedButton(
              onPressed: widget.onPress,
              style: widget.styleConfirm,
              child: Text(
                widget.textConfirmBtn,
                textAlign: TextAlign.center,
                style: widget.textStyleConfirm,
              )),
        ),
      ],
    );
  }
}