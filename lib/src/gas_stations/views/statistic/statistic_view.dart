import 'package:flutter/material.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart' show Statistic;

class StatisticView extends StatelessWidget {
  const StatisticView({super.key, required this.statistic});
  final Statistic? statistic;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: statistic?.stats
              .map<Widget>(
                (e) => Text(
                  '${e.name}\n${e.mean}\n${e.median}\n${e.count}',
                ),
              )
              .toList(growable: false) ??
          const <Widget>[],
    );
  }
}
