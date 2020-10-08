import 'package:spotfinder/models/spot.model.dart';
import 'package:spotfinder/services/rest.service.dart';

class Repository {
  Repository._privateConstructor();

  static final Repository _instance = Repository._privateConstructor();

  factory Repository() {
    return _instance;
  }

  Future<List<Spot>> getSpots() {
    return RestService().getSpots();
  }
}
