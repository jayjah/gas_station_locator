import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/util/date_helper.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart' show Station, Fuel;

class GasStationTile extends StatelessWidget {
  const GasStationTile({
    super.key,
    required this.gasStation,
    required this.currentLatitude,
    required this.currentLongitude,
  });
  final Station gasStation;
  final double? currentLatitude;
  final double? currentLongitude;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 12, right: 12),
      leading: currentLongitude != null && currentLatitude != null
          ? Text(
              '${_calculateDistance(currentLatitude!, currentLongitude!, gasStation.latitude, gasStation.longitude)} km',
            )
          : null,
      trailing: IconButton(
        onPressed: _launchMap,
        icon: const Icon(Icons.navigation_outlined),
      ),
      title: Text(
        '${gasStation.name} ${gasStation.brand}',
        textAlign: TextAlign.center,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Text(
            '${gasStation.street} ${gasStation.postalCode} ${gasStation.place}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 5,
          ),
          ...gasStation.fuels
              .map<Widget>(
                (Fuel e) => Text(
                  '${e.name} = ${e.price}   Update: ${e.lastChange.timeStamp.toHourMinuteDayMonth}',
                ),
              )
              .toList(growable: false),
        ]),
      ),
    );
  }

  Future<void> _launchMap() async {
    final List<AvailableMap> availableMaps = await MapLauncher.installedMaps;

    if (availableMaps.isNotEmpty)
      // ignore: curly_braces_in_flow_control_structures
      await availableMaps.first.showMarker(
        coords: Coords(gasStation.latitude, gasStation.longitude),
        title: gasStation.name,
      );
  }
}

int _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double p = 0.017453292519943295;
  final double a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

  return (12742 * asin(sqrt(a))).floor();
}
