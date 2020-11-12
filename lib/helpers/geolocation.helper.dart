import 'package:geolocator/geolocator.dart';

class GeolocationHelper {
  GeolocationHelper._privateConstructor();

  static final GeolocationHelper instance =
      GeolocationHelper._privateConstructor();

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
}
