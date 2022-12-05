import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/address_container.dart';
import 'package:location/location.dart' show LocationData;
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart'
    show Statistic, StatisticType;

class StatisticView extends StatelessWidget {
  const StatisticView({
    super.key,
    required this.statistic,
    required this.currentLocation,
    required this.currentAddress,
  });
  final Statistic? statistic;
  final LocationData currentLocation;
  final String currentAddress;
  @override
  Widget build(BuildContext context) {
    const EdgeInsets textPadding = EdgeInsets.all(8.0);

    return Column(
      children: <Widget>[
        Center(
          child: AddressContainer(
            address: currentAddress,
            latitude: currentLocation.latitude,
            longitude: currentLocation.longitude,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        if (statistic != null)
          ...statistic!.stats.map<Widget>(
            (StatisticType e) => Padding(
              padding: textPadding,
              child: Text(
                '${e.name.name}\nMean: ${e.mean}  Count: ${e.count}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
