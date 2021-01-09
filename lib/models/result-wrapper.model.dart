import 'package:spotfinder/models/comment.model.dart';
import 'package:spotfinder/models/pagination.model.dart';
import 'package:spotfinder/models/picture.model.dart';
import 'package:spotfinder/models/spot.model.dart';

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

  static ResultWrapper fromJson<T>(Map<String, dynamic> json, T result) {
    return ResultWrapper<T>(json['statusCode'], json['time'], result);
  }

  static ResultWrapper fromJsonMap<T>(Map<String, dynamic> json) {
    List<dynamic> resultJson = json['result'];

    if (T == Spot) {
      List<Spot> spots = Spot.fromJsonList(resultJson);
      Map<String, dynamic> paginationJson = json['pagination'];
      // Serialize Pagination
      Pagination pagination = Pagination.fromJson(paginationJson);
      // Création du ResultWrapper
      ResultWrapper<List<Spot>> rw =
          ResultWrapper.fromJson<List<Spot>>(json, spots);
      rw.pagination = pagination;
      return rw;
    } else if (T == Picture) {
      List<Picture> pictures = Picture.fromJsonList(resultJson);
      // Serialize Pagination
      Map<String, dynamic> paginationJson = json['pagination'];
      Pagination pagination = Pagination.fromJson(paginationJson);
      // Création du ResultWrapper
      ResultWrapper<List<Picture>> rw =
          ResultWrapper.fromJson<List<Picture>>(json, pictures);
      rw.pagination = pagination;

      return rw;
    } else if (T == Comment){
       List<Comment> comments = Comment.fromJsonList(resultJson);
      // Serialize Pagination
      Map<String, dynamic> paginationJson = json['pagination'];
      Pagination pagination = Pagination.fromJson(paginationJson);
      // Création du ResultWrapper
      ResultWrapper<List<Comment>> rw =
          ResultWrapper.fromJson<List<Comment>>(json, comments);
      rw.pagination = pagination;

      return rw;
    } else {
      throw Exception('Unknown type');
    }
  }
}
