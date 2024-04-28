class UserModel {
  String? auth;
  String? userName;
  String? password;
  String? email;
  String? phoneNo;
  String? profile;

  UserModel({this.userName, this.phoneNo,this.password, this.email,this.profile,this.auth});

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    password = json['password'];
    email = json['email'];
    phoneNo = json['phone_no'];
    profile = json['profile'];
    auth = json['auth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['password'] = this.password;
    data['email'] = this.email;
    data['phone_no'] = this.phoneNo;
    data['profile'] = this.profile;
    data['auth'] = this.auth;
    return data;
  }
}
