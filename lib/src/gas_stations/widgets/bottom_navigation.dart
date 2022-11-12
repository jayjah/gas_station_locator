import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/gas_stations_handler.dart'
    show ViewMode, kSearchAroundLabel, kPostalCodeLabel;

typedef OnViewModeChanged = void Function(ViewMode nextMode);

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.onNextView,
    this.items = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: kSearchAroundLabel,
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.location_city_outlined),
        label: kPostalCodeLabel,
      ),
    ],
  });
  final List<BottomNavigationBarItem> items;
  final OnViewModeChanged onNextView;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _onTap,
      items: items,
    );
  }

  void _onTap(int? index) {
    if (index == null) return;

    final BottomNavigationBarItem nextItem = items[index];

    final ViewMode next = ViewMode.values.firstWhere((ViewMode element) {
      return element.message.toLowerCase().trim() ==
          nextItem.label!.toLowerCase().trim();
    });

    onNextView(next);
  }
}
