import 'package:spotfinder/models/spot.model.dart';

class SpotMocks {
  static Spot getSpot() {
    return Spot(
        'UUID GENERATE',
        'Ce spot est magnifique, les rampes sont géniales, et tout est en place pour profiter au maximum ! ',
        'Hipnotic Cable Park',
        'Rue du lac, 64 4712 Neupré',
        'France',
        12,
        45565454,
        55454566,
        1602009832,
        1602009832,
        true,
        'UUID RIDER');
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
