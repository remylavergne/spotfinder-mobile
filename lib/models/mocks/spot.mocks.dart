import 'package:spotfinder/models/spot.model.dart';

class SpotMocks {
  static Spot getSpot() {
    return null;
  }

  static List<Spot> getSpots() {
    return [
      getSpot(),
      getSpot(),
      getSpot(),
      getSpot(),
      getSpot(),
      getSpot(),
      getSpot(),
    ];
  }
}
