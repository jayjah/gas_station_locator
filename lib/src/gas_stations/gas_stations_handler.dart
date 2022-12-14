import 'package:flutter/material.dart' show ChangeNotifier, debugPrint;
import 'package:gasstation_locator/src/env.dart';
import 'package:gasstation_locator/src/logger.dart';
import 'package:geocode/geocode.dart' show GeoCode, Address;
import 'package:location/location.dart'
    show LocationData, getLocation, LocationSettings;
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart';

enum Filter {
  e5,
  e10,
  diesel,
}

const String kSearchAroundLabel = 'Search around';
const String kPostalCodeLabel = 'Search for postal code';
const String kStatistics = 'Statistics';

enum ViewMode {
  searchAround(kSearchAroundLabel),
  searchForPostalCode(kPostalCodeLabel),
  statistics(kStatistics);

  const ViewMode(this.message);
  final String message;
}

class GasStationHandler with ChangeNotifier {
  late final TankerKoenigApi _api =
      TankerKoenigApi(Env.instance.tankerKoenigToken);
  late final GeoCode _reverseGeoCoding = GeoCode();

  LocationData? _currentLocation;
  Address? _currentAddress;
  Iterable<Station>? _stations;
  int _radiusInKm = 15;
  Filter _currentFilter = Filter.diesel;
  bool _loading = true;
  ViewMode _currentViewMode = ViewMode.searchAround;
  int _postalCode = -1;
  Statistic? _statistic;

  GasStationHandler();

  void updateLocations() =>
      _updateCurrentLocation().whenComplete(_retrieveGasStationsByLatLng);

  set updateRadius(int radius) {
    _loading = true;
    _radiusInKm = radius;
    notifyListeners();
    _retrieveGasStationsByLatLng();
  }

  set updatePostalCode(int postalCode) {
    if (postalCode <= 0) return;

    _postalCode = postalCode;
    _loading = true;
    notifyListeners();
    _retrieveGasStationsByPostalCode();
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
    notifyListeners();
  }

  set updateViewMode(ViewMode viewMode) {
    _currentViewMode = viewMode;
    _stations = <Station>[];
    notifyListeners();

    switch (_currentViewMode) {
      case ViewMode.searchAround:
        _retrieveGasStationsByLatLng();
        break;
      case ViewMode.searchForPostalCode:
        if (_postalCode != -1) _retrieveGasStationsByPostalCode();
        break;
      case ViewMode.statistics:
        if (_statistic == null) _retrieveStatistics();
        break;
    }
  }

  int get currentPostalCode => _postalCode;

  Statistic? get statistic => _statistic;

  int get currentRadius => _radiusInKm;

  Filter get currentFilter => _currentFilter;

  LocationData? get currentLocation => _currentLocation;

  Iterable<Station>? get stations => _stations;

  bool get isLoading => _loading;

  String get currentAddress =>
      '${_currentAddress?.streetAddress ?? ''} ${_currentAddress?.streetNumber ?? ''}\n${_currentAddress?.postal ?? ''} ${_currentAddress?.city ?? ''}';

  ViewMode get currentViewMode => _currentViewMode;

  Future<void> _updateCurrentLocation() async {
    _loading = true;
    _currentLocation = await getLocation(
      settings: LocationSettings(
        askForGPS: true,
        askForPermission: true,
        useGooglePlayServices: false,
        waitForAccurateLocation: true,
      ),
    );
    if (_currentLocation?.latitude != null &&
        _currentLocation?.longitude != null)
      // ignore: curly_braces_in_flow_control_structures
      try {
        _currentAddress = await _reverseGeoCoding.reverseGeocoding(
          latitude: _currentLocation!.latitude!,
          longitude: _currentLocation!.longitude!,
        );
      } catch (e, stackTrace) {
        debugPrint('Error happened: $e \n $stackTrace');
      }
    debugPrint('current location: $_currentLocation');
    debugPrint('current address: $_currentAddress');
    notifyListeners();
  }

  Future<void> _retrieveGasStationsByPostalCode() async {
    final DateTime now = DateTime.now();
    try {
      _stations = (await _api.stationsByPostalCode(
        postalCode: _postalCode,
      ))
          ?.filterForOpenCloseTime(now)
          .toList(growable: false)
        ?..sortByFilter(_currentFilter);
    } catch (e, stackTrace) {
      await Logger.instance.logError(
        'stationsByPostalCode error: $e',
        stackTrace: stackTrace,
      );
      _stations = <Station>[];
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> _retrieveStatistics() async {
    _loading = true;
    notifyListeners();
    try {
      _statistic = await _api.statistics();
    } catch (e, stackTrace) {
      await Logger.instance.logError(
        'statistics error: $e',
        stackTrace: stackTrace,
      );
      _statistic = null;
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> _retrieveGasStationsByLatLng() async {
    final DateTime now = DateTime.now();
    try {
      _stations = (await _api.stationsByLatLng(
        latitude: _currentLocation?.latitude ?? 0.0,
        longitude: _currentLocation?.longitude ?? 0.0,
        radius: _radiusInKm,
      ))
          ?.filterForOpenCloseTime(now)
          .toList(growable: false)
        ?..sortByFilter(_currentFilter);
    } catch (e, stackTrace) {
      await Logger.instance.logError(
        'stationsByLatLng error: $e',
        stackTrace: stackTrace,
      );
      _stations = <Station>[];
    }
    _loading = false;
    notifyListeners();
  }
}

extension FilterForOpen on Iterable<Station> {
  Iterable<Station> filterForOpenCloseTime(DateTime now) =>
      where((Station element) =>
          (element.opensAt?.isBefore(now) ?? true) &&
          (element.closesAt?.isAfter(now) ?? true));
}

extension Sorting on List<Station> {
  void sortByFilter(Filter filter) => sort((Station t1, Station t2) {
        switch (filter) {
          case Filter.e5:
            return t1.e5Price.compareTo(t2.e5Price);
          case Filter.e10:
            return t1.e10Price.compareTo(t2.e10Price);
          case Filter.diesel:
            return t1.dieselPrice.compareTo(t2.dieselPrice);
        }
      });
}
