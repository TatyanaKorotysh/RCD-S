class UserModel {
  String login;
  String password;
  bool isAdmin;

  UserModel(this.login, this.password, this.isAdmin);

  UserModel.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    password = json['password'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['password'] = this.password;
    data['isAdmin'] = this.isAdmin;
    return data;
  }
}
