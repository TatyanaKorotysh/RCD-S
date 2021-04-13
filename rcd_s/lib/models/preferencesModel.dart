class PreferencesModel {
  String login;
  String lang;
  String theme;

  PreferencesModel(this.login, this.lang, this.theme);

  PreferencesModel.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    lang = json['lang'];
    theme = json['theme'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['${this.login}'] = [this.lang, this.theme];
    return data;
  }
}
