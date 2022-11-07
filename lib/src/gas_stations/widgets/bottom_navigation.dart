import 'package:flutter/material.dart';

enum ViewMode {
  searchAround,
  searchForPostalCode,
}

typedef OnViewModeChanged = void Function(ViewMode nextMode);

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.onNextView,
    this.items = const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search around',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.location_city_outlined),
        label: 'Search for postal code',
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
    final ViewMode next = ViewMode.values.firstWhere(
      (ViewMode element) =>
          element.name.toLowerCase().trim() == nextItem.label!,
    );

    onNextView(next);
  }
}
