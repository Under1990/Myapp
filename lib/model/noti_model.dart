import 'package:firebase_database/firebase_database.dart';

class NotiModel {
  String? title;
  String? description;
  String? dateInput;

  NotiModel({this.title, this.description, this.dateInput});

  NotiModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    dateInput = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['date'] = this.dateInput;
    return data;
  }
}
