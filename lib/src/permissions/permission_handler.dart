import 'package:flutter/material.dart' show ChangeNotifier, debugPrint;
import 'package:location/location.dart';

class PermissionHandler with ChangeNotifier {
  late final Location _location = Location();
  bool _gpsServiceEnabled = false;
  bool _permissionGiven = false;
  bool _loading = true;

  PermissionHandler();

  bool get gpsServiceEnabled => _gpsServiceEnabled;

  bool get gpsPermissionGiven => _permissionGiven;

  bool get isLoading => _loading;

  void checkPermissions() =>
      _checkGpsService().whenComplete(_checkGpsPermission);

  Future<void> _checkGpsService() async {
    _loading = true;
    notifyListeners();
    _gpsServiceEnabled = await _location.serviceEnabled();
    if (!_gpsServiceEnabled) await _location.requestService();
    debugPrint('check permissions :: service enabled: $_gpsServiceEnabled');
    notifyListeners();
  }

  Future<void> _checkGpsPermission() async {
    _permissionGiven =
        await _location.hasPermission() == PermissionStatus.granted;
    if (!_permissionGiven) await _location.requestPermission();
    debugPrint('check permissions :: permissionGranted: $_permissionGiven');
    _loading = false;
    notifyListeners();
  }
}
