import 'package:spotfinder/models/pagination.model.dart';

class ResultWrapper<T> {
  int statusCode;
  int time;
  T result;
  Pagination pagination;

  ResultWrapper(int statusCode, int time, [T result, Pagination pagination]) {
    this.statusCode = statusCode;
    this.time = time;
    this.result = result;
    this.pagination = pagination;
  }

  factory ResultWrapper.fromJson(Map<String, dynamic> json, T result) {
    return ResultWrapper(json['statusCode'], json['time'], result);
  }
}
