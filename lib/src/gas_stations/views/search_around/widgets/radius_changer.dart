import 'package:flutter/material.dart';

typedef OnRadiusChanged = void Function(int radius);

class RadiusChanger extends StatefulWidget {
  const RadiusChanger({
    super.key,
    required this.startRadius,
    required this.onRadiusChange,
  });
  final int startRadius;
  final OnRadiusChanged onRadiusChange;
  @override
  State<RadiusChanger> createState() => _RadiusChangerState();
}

class _RadiusChangerState extends State<RadiusChanger> {
  late double _currentRadius = widget.startRadius / 100;

  @override
  Widget build(BuildContext context) {
    const TextStyle defaultStyle = TextStyle(fontSize: 16);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 12,
          ),
          const Text('Radius changer', style: defaultStyle),
          Slider(
            value: _currentRadius,
            onChanged: (double? newRadius) {
              if (newRadius == null) return;

              setState(() {
                _currentRadius = newRadius;
              });
              widget.onRadiusChange((_currentRadius * 100).toInt());
            },
          ),
          Text('Current radius: ${(_currentRadius * 100).toInt()} km'),
        ],
      ),
    );
  }
}
