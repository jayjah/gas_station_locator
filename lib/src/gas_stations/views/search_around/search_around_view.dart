import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/gas_stations_handler.dart'
    show Filter;
import 'package:gasstation_locator/src/gas_stations/views/search_around/widgets/filter_changer.dart';
import 'package:gasstation_locator/src/gas_stations/views/search_around/widgets/radius_changer.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/address_container.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/gas_station_list.dart';
import 'package:location/location.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart' show Station;

class SearchAroundView extends StatefulWidget {
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
  State<SearchAroundView> createState() => _SearchAroundViewState();
}

class _SearchAroundViewState extends State<SearchAroundView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double? latitude = widget.currentLocation.latitude;
    final double? longitude = widget.currentLocation.longitude;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AddressContainer(
          address: widget.currentAddress,
          latitude: latitude,
          longitude: longitude,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RadiusChanger(
              startRadius: widget.currentRadius,
              onRadiusChange: widget.onRadiusChange,
            ),
            FilterChanger(
              startFilter: widget.currentFilter,
              onFilterChange: widget.onFilterChange,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        GasStationList(
          stations: widget.stations,
          currentLatitude: latitude,
          currentLongitude: longitude,
          scrollController: _scrollController,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
