// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/gas_stations_handler.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/address_container.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/error_text.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/filter_changer.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/gas_station_tile.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/radius_changer.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/scaffold_container.dart';
import 'package:location/location.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart';

class GasStationSearcherWidget extends StatefulWidget {
  const GasStationSearcherWidget({super.key});

  @override
  State<GasStationSearcherWidget> createState() =>
      _GasStationSearcherWidgetState();
}

class _GasStationSearcherWidgetState extends State<GasStationSearcherWidget> {
  final GasStationHandler _handler = GasStationHandler();

  @override
  void initState() {
    super.initState();
    _handler.updateLocations();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldContainer(
      builder: (BuildContext context) {
        return AnimatedBuilder(
          animation: _handler,
          builder: (BuildContext context, Widget? _) {
            if (_handler.isLoading)
              return const Center(child: CircularProgressIndicator.adaptive());

            final LocationData? currentLocation = _handler.currentLocation;
            if (currentLocation == null)
              return const ErrorText(content: 'Current location unknown!');

            final Iterable<Station>? stations = _handler.stations;
            if (stations == null)
              return ErrorText(
                content:
                    'No gas stations are known for location(latitude: ${currentLocation.latitude ?? 0.0} longitude: ${currentLocation.longitude ?? 0.0})',
              );

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //TODO(jayjah): add page to search for postal code

                AddressContainer(
                  address: _handler.currentAddress,
                  latitude: currentLocation.latitude,
                  longitude: currentLocation.longitude,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RadiusChanger(
                      startRadius: _handler.currentRadius,
                      onRadiusChange: (int radius) =>
                          _handler.updateRadius = radius,
                    ),
                    FilterChanger(
                      startFilter: _handler.currentFilter,
                      onFilterChange: (Filter filter) =>
                          _handler.updateFilter = filter,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: stations.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Station gasStation = stations.elementAt(index);

                      return GasStationTile(gasStation: gasStation);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
