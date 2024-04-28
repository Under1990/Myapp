///json ในการเก็บข้อมูล login
class LoginDataModel {
  String? authId;
  String? password;
  String? email;

  LoginDataModel({this.authId, this.password, this.email});

  LoginDataModel.fromJson(Map<String, dynamic> json) {
    authId = json['user_name'];
    password = json['password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.authId;
    data['password'] = this.password;
    data['email'] = this.email;
    return data;
  }
}
