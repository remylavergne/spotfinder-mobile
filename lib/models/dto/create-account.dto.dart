import 'dart:convert';

class CreateAccount {
  String username;
  String email;

  CreateAccount(String username, String email) {
    this.username = username;
    this.email = email;
  }

  String toDto() {
    return jsonEncode(
        <String, String>{'username': this.username, 'email': this.email});
  }
}
