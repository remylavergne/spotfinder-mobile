import 'dart:convert';

class SearchWithPagination {
  String id;
  int page;
  int limit;

  SearchWithPagination(String id, int page, int limit) {
    this.id = id;
    this.page = page;
    this.limit = limit;
  }

  static fromMap(Map<String, dynamic> map) {
    return new SearchWithPagination(map['id'], map['page'], map['limit']);
  }

  String toJson() {
    return jsonEncode(<String, String>{
      'id': this.id,
      'page': this.page.toString(),
      'limit': this.limit.toString()
    });
  }
}
