class NewAccount {
  String id;
  String username;
  String password;
  String token;

  NewAccount(String id, String username, String password, String token) {
    this.id = id;
    this.username = username;
    this.password = password;
    this.token = token;
  }

  static NewAccount fromJson(Map<String, dynamic> json) {
    return NewAccount(
        json['id'], json['username'], json['password'], json['token']);
  }
}
