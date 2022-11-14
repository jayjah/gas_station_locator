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
    const TextStyle defaultStyle = TextStyle(fontSize: 16);

    return Container(
      width: MediaQuery.of(context).size.width - 25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: <BoxShadow>[BoxShadow(color: Colors.black.withOpacity(0.3))],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 8,
          ),
          Text(
            address,
            style: defaultStyle,
            textAlign: TextAlign.center,
          ),
          Text(
            'latitude = $latitude  |  longitude = $longitude',
            style: defaultStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
