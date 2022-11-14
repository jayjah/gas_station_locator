import 'package:flutter/material.dart' show ChangeNotifier, debugPrint;
import 'package:location/location.dart';

class PermissionHandler with ChangeNotifier {
  bool _gpsServiceEnabled = false;
  bool _permissionGiven = false;
  bool _loading = false;

  PermissionHandler();

  bool get gpsServiceEnabled => _gpsServiceEnabled;

  bool get gpsPermissionGiven => _permissionGiven;

  bool get isLoading => _loading;

  void checkPermissions() =>
      _checkGpsService().whenComplete(_checkGpsPermission);

  Future<void> _checkGpsService() async {
    if (_loading) return;
    _loading = true;
    notifyListeners();
    _gpsServiceEnabled = await isGPSEnabled();
    //if (!_gpsServiceEnabled) await requestService();
    debugPrint('check permissions :: service enabled: $_gpsServiceEnabled');
    notifyListeners();
  }

  Future<void> _checkGpsPermission() async {
    final PermissionStatus permission = await getPermissionStatus();

    _permissionGiven = permission == PermissionStatus.authorizedAlways ||
        permission == PermissionStatus.authorizedWhenInUse;
    if (!_permissionGiven) await requestPermission();
    debugPrint('check permissions :: permissionGranted: $_permissionGiven');
    _loading = false;
    notifyListeners();
  }
}
