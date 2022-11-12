import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/gas_station_tile.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart' show Station;

class GasStationList extends StatelessWidget {
  const GasStationList({
    super.key,
    required this.stations,
  });
  final Iterable<Station> stations;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: stations.length,
        itemBuilder: (BuildContext context, int index) {
          final Station gasStation = stations.elementAt(index);

          return GasStationTile(gasStation: gasStation);
        },
      ),
    );
  }
}
