class WifiModel {
  String ssid;
  String password;

  WifiModel(this.ssid, this.password);

  WifiModel.fromJson(Map<String, dynamic> json) {
    ssid = json['ssid'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ssid'] = this.ssid;
    data['password'] = this.password;
    return data;
  }
}
