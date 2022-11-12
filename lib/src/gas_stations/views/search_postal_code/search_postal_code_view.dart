import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/address_container.dart';
import 'package:gasstation_locator/src/gas_stations/widgets/gas_station_list.dart';
import 'package:location/location.dart';
import 'package:tankerkoenig_dart/tankerkoenig_dart.dart' show Station;

typedef OnSearchForPostalCode = void Function(int postalCode);

class SearchPostalCodeView extends StatefulWidget {
  const SearchPostalCodeView({
    super.key,
    required this.currentAddress,
    required this.currentLocation,
    required this.onSearchForPostalCode,
    required this.stations,
  });
  final LocationData currentLocation;
  final String currentAddress;
  final OnSearchForPostalCode onSearchForPostalCode;
  final Iterable<Station> stations;
  @override
  State<SearchPostalCodeView> createState() => _SearchPostalCodeViewState();
}

class _SearchPostalCodeViewState extends State<SearchPostalCodeView> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AddressContainer(
          address: widget.currentAddress,
          latitude: widget.currentLocation.latitude,
          longitude: widget.currentLocation.longitude,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.number,
              ),
            ),
            IconButton(
              onPressed: () {
                final int? postalCode =
                    int.tryParse(_textEditingController.text);
                if (postalCode != null)
                  // ignore: curly_braces_in_flow_control_structures
                  widget.onSearchForPostalCode(postalCode);
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GasStationList(stations: widget.stations),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
