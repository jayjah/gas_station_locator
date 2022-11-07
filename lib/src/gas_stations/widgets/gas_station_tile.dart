import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/util/date_helper.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart' show Station, Fuel;

class GasStationTile extends StatelessWidget {
  const GasStationTile({
    super.key,
    required this.gasStation,
  });
  final Station gasStation;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 12, right: 12),
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
}
