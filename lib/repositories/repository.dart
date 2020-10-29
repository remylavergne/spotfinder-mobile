import 'package:spotfinder/models/result-wrapper.model.dart';
import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/services/global-rest.service.dart';

class Repository {
  Repository._privateConstructor();

  static final Repository _instance = Repository._privateConstructor();

  factory Repository() {
    return _instance;
  }

  Future<List<Spot>> getSpots() {
    return RestService().getSpots();
  }

   Future<ResultWrapper<List<Spot>>> getPaginatedSpots(int page, int limit) {
     return RestService().getPaginatedSpots(page, limit);
   }


}
