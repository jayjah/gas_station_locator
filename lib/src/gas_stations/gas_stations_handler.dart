import 'package:flutter/material.dart' show ChangeNotifier, debugPrint;
import 'package:location/location.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart';

const String _kApiKey = 'c2e9b4de-1aa2-22eb-3284-a24b4cf1a9fd';

enum Filter {
  e5,
  e10,
  diesel,
}

class GasStationHandler with ChangeNotifier {
  late final Location _location = Location();
  late final TankerKoenigApi _api = TankerKoenigApi(_kApiKey);

  LocationData? _currentLocation;
  Iterable<Station>? _stations;
  int _radiusInKm = 15;
  Filter _currentFilter = Filter.diesel;
  bool _loading = true;

  GasStationHandler();

  bool get isLoading => _loading;

  void updateLocations() =>
      _updateCurrentLocation().whenComplete(_retrieveGasStations);

  set updateRadius(int radius) {
    _loading = true;
    _radiusInKm = radius;
    debugPrint('new radius: $_radiusInKm');
    _retrieveGasStations();
  }

  set updateFilter(Filter filter) {
    _loading = true;
    _currentFilter = filter;
    debugPrint('new filter: $_currentFilter');
    _retrieveGasStations();
  }

  LocationData? get currentLocation => _currentLocation;

  Iterable<Station>? get stations => _stations;

  Future<void> _updateCurrentLocation() async {
    _loading = true;
    _currentLocation = await _location.getLocation();
    debugPrint('current location: $_currentLocation');
    notifyListeners();
  }

  Future<void> _retrieveGasStations() async {
    final DateTime now = DateTime.now();
    _stations = (await _api.stationsByLatLng(
      latitude: _currentLocation?.latitude ?? 0.0,
      longitude: _currentLocation?.longitude ?? 0.0,
      radius: _radiusInKm,
    ))
        ?.where((Station element) =>
            (element.opensAt?.isBefore(now) ?? true) &&
            (element.closesAt?.isAfter(now) ?? true))
        .toList(growable: false)
      ?..sort((Station t1, Station t2) {
        switch (_currentFilter) {
          case Filter.e5:
            return t1.e5Price.compareTo(t2.e5Price);
          case Filter.e10:
            return t1.e10Price.compareTo(t2.e10Price);
          case Filter.diesel:
            return t1.dieselPrice.compareTo(t2.dieselPrice);
        }
      });
    _loading = false;
    debugPrint('all stations: ${_stations?.toList()}');
    notifyListeners();
  }
}
