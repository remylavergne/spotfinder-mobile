import 'dart:convert';

class SearchDto {
  String query;

  SearchDto(String query) {
    this.query = query;
  }

  String toDto() {
    return jsonEncode(<String, String>{'query': this.query});
  }
}
