class UserData {
  String? userId;
  String? userName;
  String? password;
  String? phoneNumber;
  String? email;
  String? token;
  int? isDeleted;

  UserData({
    this.userId,
    this.userName,
    this.password,
    this.phoneNumber,
    this.email,
    this.token,
    this.isDeleted,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    password = json['password'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    token = json['token'];
    isDeleted = json['is_deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['password'] = this.password;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['token'] = this.token;
    data['is_deleted'] = this.isDeleted;
    return data;
  }
}
