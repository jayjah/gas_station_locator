import 'package:flutter/material.dart' show ChangeNotifier, debugPrint;
import 'package:geocode/geocode.dart';
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
  late final GeoCode _reverseGeoCoding = GeoCode();

  LocationData? _currentLocation;
  Address? _currentAddress;
  Iterable<Station>? _stations;
  int _radiusInKm = 15;
  Filter _currentFilter = Filter.diesel;
  bool _loading = true;

  GasStationHandler();

  void updateLocations() =>
      _updateCurrentLocation().whenComplete(_retrieveGasStationsByLatLng);

  set updateRadius(int radius) {
    _loading = true;
    _radiusInKm = radius;
    debugPrint('new radius: $_radiusInKm');
    notifyListeners();
    _retrieveGasStationsByLatLng();
  }

  set updateFilter(Filter filter) {
    _currentFilter = filter;
    _stations = _stations?.toList(growable: false)
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
    debugPrint('new filter: $_currentFilter');
    notifyListeners();
  }

  int get currentRadius => _radiusInKm;

  Filter get currentFilter => _currentFilter;

  LocationData? get currentLocation => _currentLocation;

  Iterable<Station>? get stations => _stations;

  bool get isLoading => _loading;

  String get currentAddress =>
      '${_currentAddress?.streetAddress ?? ''} ${_currentAddress?.streetNumber ?? ''}\n${_currentAddress?.postal ?? ''} ${_currentAddress?.city ?? ''}';

  Future<void> _updateCurrentLocation() async {
    _loading = true;
    _currentLocation = await _location.getLocation();
    if (_currentLocation?.latitude != null &&
        _currentLocation?.longitude != null)
      // ignore: curly_braces_in_flow_control_structures
      _currentAddress = await _reverseGeoCoding.reverseGeocoding(
        latitude: _currentLocation!.latitude!,
        longitude: _currentLocation!.longitude!,
      );
    debugPrint('current location: $_currentLocation');
    debugPrint('current address: $_currentAddress');
    notifyListeners();
  }

  Future<void> _retrieveGasStationsByPostalCode() async {
    final DateTime now = DateTime.now();
  }

  Future<void> _retrieveGasStationsByLatLng() async {
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
