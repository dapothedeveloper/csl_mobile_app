import 'package:location/location.dart';
// import 'package:geolocator/geolocator.dart';

class GeoLocation {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  Future<LocationData> getCoordinates() async {
    _serviceEnabled = await location.serviceEnabled();
    try {
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }

      _locationData = await location.getLocation();

      return _locationData;
    } catch (e) {
      return e;
    }
  }

  // Future getLocation(double longitude, double latitude) {
  //   // return "$latitude $longitude";

  // }
}
