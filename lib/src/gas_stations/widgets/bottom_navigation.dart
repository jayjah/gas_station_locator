import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/gas_stations_handler.dart'
    show ViewMode, kPostalCodeLabel, kSearchAroundLabel, kStatistics;

typedef OnViewModeChanged = void Function(ViewMode nextMode);

class BottomNavigation extends StatefulWidget {
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
      BottomNavigationBarItem(
        icon: Icon(Icons.stacked_bar_chart),
        label: kStatistics,
      ),
    ],
  });
  final List<BottomNavigationBarItem> items;
  final OnViewModeChanged onNextView;

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTap,
      items: widget.items,
    );
  }

  void _onTap(int? index) {
    if (index == null) return;

    final BottomNavigationBarItem nextItem = widget.items[index];

    final ViewMode next = ViewMode.values.firstWhere((ViewMode element) {
      return element.message.toLowerCase().trim() ==
          nextItem.label!.toLowerCase().trim();
    });
    setState(() {
      _currentIndex = index;
    });

    widget.onNextView(next);
  }
}
