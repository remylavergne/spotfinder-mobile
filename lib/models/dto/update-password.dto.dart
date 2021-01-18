import 'dart:convert';

class UpdatePassword {
  String userId;
  String currentPassword;
  String newPassword;

  UpdatePassword(String userId, String currentPassword, String newPassword) {
    this.userId = userId;
    this.currentPassword = currentPassword;
    this.newPassword = newPassword;
  }

  String toJson() {
    return jsonEncode(<String, String>{
      'userId': this.userId,
      'currentPassword': this.currentPassword,
      'newPassword': this.newPassword
    });
  }
}
