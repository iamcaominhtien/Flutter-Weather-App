import 'package:location/location.dart';

class MyLocation {
  double? longitude, latitude;

  MyLocation({this.longitude, this.latitude});

  Future<bool> getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      //Yêu cầu lại quyền một lần nữa. 
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    try {
      LocationData _locationData = await location.getLocation();
      longitude = _locationData.longitude ?? 0;
      latitude = _locationData.latitude ?? 0;
    } catch (e) {
      return false;
    }
    return true;
  }
}
