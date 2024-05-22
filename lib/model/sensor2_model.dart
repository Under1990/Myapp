class Sensor2DataModel {
  Object? tempData;
  DateTime? date;

  Sensor2DataModel({this.tempData, this.date});

  Sensor2DataModel.fromJson(Map<String, dynamic> json) {
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