import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/error_text.dart';
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: const Border.symmetric(),
          color: Colors.black12.withOpacity(0.5),
        ),
        child: stations.isEmpty
            ? const ErrorText(content: 'Unfortunately no data available')
            : _List(
                stations: stations,
                currentLongitude: currentLongitude,
                currentLatitude: currentLatitude,
                scrollController: scrollController,
              ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({
    // ignore: unused_element
    super.key,
    required this.stations,
    required this.currentLongitude,
    required this.currentLatitude,
    required this.scrollController,
  });
  final Iterable<Station> stations;
  final ScrollController scrollController;
  final double? currentLatitude;
  final double? currentLongitude;
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        itemCount: stations.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (BuildContext context, int index) {
          final Station gasStation = stations.elementAt(index);

          return GasStationTile(
            gasStation: gasStation,
            currentLatitude: currentLatitude,
            currentLongitude: currentLongitude,
          );
        },
      ),
    );
  }
}
