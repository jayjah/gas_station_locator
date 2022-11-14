import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/gas_station_tile.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart' show Station;

class GasStationList extends StatelessWidget {
  const GasStationList({
    super.key,
    required this.stations,
    required this.currentLongitude,
    required this.currentLatitude,
    required this.scrollController,
  });
  final Iterable<Station> stations;
  final double? currentLatitude;
  final double? currentLongitude;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: stations.length,
          itemBuilder: (BuildContext context, int index) {
            final Station gasStation = stations.elementAt(index);

            return GasStationTile(
              gasStation: gasStation,
              currentLatitude: currentLatitude,
              currentLongitude: currentLongitude,
            );
          },
        ),
      ),
    );
  }
}
