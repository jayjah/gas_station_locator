// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/gas_stations_handler.dart';
import 'package:gasstation_locator/src/gas_stations/views/search_around/search_around_view.dart';
import 'package:gasstation_locator/src/gas_stations/views/search_postal_code/search_postal_code_view.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/bottom_navigation.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/error_text.dart';
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
      key: const ValueKey<String>('scaffold'),
      bottomNavigation: BottomNavigation(
        onNextView: (ViewMode nextViewMode) =>
            _handler.updateViewMode = nextViewMode,
      ),
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ErrorText(
                    content:
                        'No gas stations found for location(latitude: ${currentLocation.latitude ?? 0.0} longitude: ${currentLocation.longitude ?? 0.0})',
                  ),
                  TextButton(
                    onPressed: _handler.updateLocations,
                    child: const Text('Retry'),
                  ),
                ],
              );

            switch (_handler.currentViewMode) {
              case ViewMode.searchAround:
                return SearchAroundView(
                  currentAddress: _handler.currentAddress,
                  currentFilter: _handler.currentFilter,
                  currentLocation: currentLocation,
                  currentRadius: _handler.currentRadius,
                  onFilterChange: (Filter filter) =>
                      _handler.updateFilter = filter,
                  onRadiusChange: (int radius) =>
                      _handler.updateRadius = radius,
                  stations: stations,
                );
              case ViewMode.searchForPostalCode:
                return SearchPostalCodeView(
                  currentLocation: currentLocation,
                  currentAddress: _handler.currentAddress,
                  firstPostalCode: _handler.currentPostalCode,
                  stations: stations,
                  onSearchForPostalCode: (int postalCode) =>
                      _handler.updatePostalCode = postalCode,
                );
            }
          },
        );
      },
    );
  }
}
