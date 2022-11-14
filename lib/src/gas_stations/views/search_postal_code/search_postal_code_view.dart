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
    required this.firstPostalCode,
  });
  final LocationData currentLocation;
  final String currentAddress;
  final OnSearchForPostalCode onSearchForPostalCode;
  final Iterable<Station> stations;
  final int firstPostalCode;
  @override
  State<SearchPostalCodeView> createState() => _SearchPostalCodeViewState();
}

class _SearchPostalCodeViewState extends State<SearchPostalCodeView> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.firstPostalCode.toString();
  }

  @override
  Widget build(BuildContext context) {
    final double? latitude = widget.currentLocation.latitude;
    final double? longitude = widget.currentLocation.longitude;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AddressContainer(
          address: widget.currentAddress,
          latitude: latitude,
          longitude: longitude,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
          ),
          child: Row(
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
        ),
        const SizedBox(height: 20),
        GasStationList(
          stations: widget.stations,
          currentLatitude: latitude,
          currentLongitude: longitude,
          scrollController: _scrollController,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
