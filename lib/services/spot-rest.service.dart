import '../models/spot.model.dart';

/**
 * Interface Spot Service
 */
class SpotService {
  Future<void> createNewSpot(Spot s) {}
  Future<List<Spot>> getSpots() {}
  Future<Spot> getSpotById(String id) {}
  Future<List<Spot>> getSpotsByRider(String id) {}
}
