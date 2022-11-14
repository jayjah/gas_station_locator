import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/gas_stations_handler.dart'
    show Filter;
import 'package:gasstation_locator/src/gas_stations/views/search_around/widgets/filter_changer.dart';
import 'package:gasstation_locator/src/gas_stations/views/search_around/widgets/radius_changer.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/address_container.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/gas_station_list.dart';
import 'package:location/location.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart' show Station;

class SearchAroundView extends StatelessWidget {
  const SearchAroundView({
    super.key,
    required this.currentFilter,
    required this.stations,
    required this.onFilterChange,
    required this.currentRadius,
    required this.currentLocation,
    required this.currentAddress,
    required this.onRadiusChange,
  });
  final LocationData currentLocation;
  final String currentAddress;
  final OnRadiusChanged onRadiusChange;
  final int currentRadius;
  final OnFilterChanged onFilterChange;
  final Iterable<Station> stations;
  final Filter currentFilter;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AddressContainer(
          address: currentAddress,
          latitude: currentLocation.latitude,
          longitude: currentLocation.longitude,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RadiusChanger(
              startRadius: currentRadius,
              onRadiusChange: onRadiusChange,
            ),
            FilterChanger(
              startFilter: currentFilter,
              onFilterChange: onFilterChange,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        GasStationList(
            stations: stations,
            currentLatitude: currentLocation.latitude,
            currentLongitude: currentLocation.longitude),
      ],
    );
  }
}
