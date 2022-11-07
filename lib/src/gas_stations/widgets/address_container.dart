import 'package:flutter/material.dart';

class AddressContainer extends StatelessWidget {
  const AddressContainer({
    super.key,
    required this.longitude,
    required this.address,
    required this.latitude,
  });
  final double? longitude;
  final double? latitude;
  final String address;
  @override
  Widget build(BuildContext context) {
    const TextStyle headerStyle = TextStyle(fontSize: 18);
    const TextStyle defaultStyle = TextStyle(fontSize: 16);

    return Column(
      children: <Widget>[
        const Text(
          'Current Address',
          style: headerStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          address,
          style: defaultStyle,
          textAlign: TextAlign.center,
        ),
        const Text(
          'Current Position',
          style: headerStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          'latitude=$latitude  |  longitude=$longitude',
          style: defaultStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
