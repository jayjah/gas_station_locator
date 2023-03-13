import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/gas_stations_handler.dart';

typedef OnFilterChanged = void Function(Filter filter);

class FilterChanger extends StatefulWidget {
  const FilterChanger({
    super.key,
    required this.startFilter,
    required this.onFilterChange,
  });
  final Filter startFilter;
  final OnFilterChanged onFilterChange;
  @override
  State<FilterChanger> createState() => _FilterChangerState();
}

class _FilterChangerState extends State<FilterChanger> {
  late Filter _currentFilter = widget.startFilter;
  @override
  Widget build(BuildContext context) {
    const TextStyle defaultStyle = TextStyle(fontSize: 16);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PopupMenuButton<Widget>(
          initialValue: PopupMenuItem<Widget>(
            enabled: false,
            child: Text(widget.startFilter.name),
          ),
          itemBuilder: (BuildContext context) {
            return Filter.values.map<PopupMenuItem<Widget>>((Filter e) {
              return PopupMenuItem<Widget>(
                child: Text(e.name),
                onTap: () {
                  setState(() {
                    _currentFilter = e;
                  });
                  widget.onFilterChange(e);
                },
              );
            }).toList(growable: false);
          },
          child: Text(
            'Current filter:\n${_currentFilter.name}',
            style: defaultStyle,
          ),
        ),
      ],
    );
  }
}
