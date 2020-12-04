class LoginInfos {
  String id;
  String username;
  String password;
  String token;

  LoginInfos(String id, String username, String password, String token) {
    this.id = id;
    this.username = username;
    this.password = password;
    this.token = token;
  }

  static LoginInfos fromJson(Map<String, dynamic> json) {
    return LoginInfos(
        json['id'], json['username'], json['password'], json['token']);
  }
}
