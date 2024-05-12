import 'package:geolocator/geolocator.dart';

class GeolocationData {
  static Position? currentPosition;
  static Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }
}
