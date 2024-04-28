import 'package:firebase_database/firebase_database.dart';

class Sensor1DataModel {
  Object? tempData;
  String? date;

  Sensor1DataModel({this.tempData, this.date});

  Sensor1DataModel.fromJson(Map<String, dynamic> json) {
    tempData = json['temp_data'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temp_data'] = this.tempData;
    data['date'] = this.date;
    return data;
  }
}
