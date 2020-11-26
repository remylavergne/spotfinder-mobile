import 'package:geolocator/geolocator.dart';
import 'package:spotfinder/models/spot.model.dart';

class GeolocationHelper {
  GeolocationHelper._privateConstructor();

  static final GeolocationHelper instance =
      GeolocationHelper._privateConstructor();

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// First time, [LocationPermission] is
  Future<LocationPermission> whichPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<bool> hasPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return true;
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
      default:
        return false;
    }
  }

  Future<bool> hasDenied() async {
    LocationPermission permission = await Geolocator.checkPermission();
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return false;
      case LocationPermission.denied:
      case LocationPermission.deniedForever:
        return false;
      default:
        return true;
    }
  }

  Future<LocationPermission> askForPermissions() async {
    return await Geolocator.requestPermission();
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Position getPositionFromSpot(Spot spot) {
    return Position(longitude: spot.longitude, latitude: spot.latitude);
  }

  double getDistanceBetweenToPosition(
      Position userPosition, Position spotPosition) {
    return Geolocator.distanceBetween(userPosition.latitude,
        userPosition.longitude, spotPosition.latitude, spotPosition.longitude);
  }

  String formatDistance(double distance) {
    if (distance < 1000) {
      return '${distance.truncate()} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(3)} km';
    }
  }
}
