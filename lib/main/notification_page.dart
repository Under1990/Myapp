import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tempapp/appManager/localstorage_manager.dart';
import 'package:tempapp/appManager/view_manager.dart';

import '../model/noti_model.dart';

class NotificationPage extends StatefulWidget {
  final String textAlert;
  final String descriptionNoti;
  final String date;

  const NotificationPage(
      {Key? key,
      required this.textAlert,
      required this.descriptionNoti,
      required this.date})
      : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager().primaryColor,
        title: Text(
          'การแจ้งเตือนล่าสุด',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Container(),
        centerTitle: true,
      ),
      body: widget.textAlert.isEmpty
          ? Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 24),
                      child: Image.asset(
                        'assets/icons/icon_empty_noti.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text(
                      'ไม่มีการแจ้งเตือน',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: ColorManager().primaryColor),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height * 0.15,
              margin: EdgeInsets.only(top: 32, left: 16, right: 16),
              padding: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorManager().primaryColor.withOpacity(0.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.textAlert,
                            textAlign: TextAlign.start,
                          ),
                          Container(
                            width: 300,
                            child: Text(
                              widget.descriptionNoti,
                              textAlign: TextAlign.start,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Text(widget.date)
                ],
              ),
            ),
    );
  }
}
