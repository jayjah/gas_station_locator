// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/gas_stations/station_searcher_widget.dart';
import 'package:gasstation_locator/src/permissions/permission_handler.dart';

class PermissionWidget extends StatefulWidget {
  const PermissionWidget({super.key});

  @override
  State<PermissionWidget> createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends State<PermissionWidget>
    with WidgetsBindingObserver {
  final ValueNotifier<AppLifecycleState> _lifecycleListenable =
      ValueNotifier<AppLifecycleState>(AppLifecycleState.inactive);
  final PermissionHandler _handler = PermissionHandler();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _handler.checkPermissions();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('LifecycleProvider :: didChangeAppLifecycleState: $state');
    if (_lifecycleListenable.value == state) return;

    _lifecycleListenable.value = state;
    _handler.checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle errorTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );

    return ValueListenableBuilder<AppLifecycleState>(
      valueListenable: _lifecycleListenable,
      builder: (BuildContext context, AppLifecycleState _, Widget? child) {
        return child!;
      },
      child: AnimatedBuilder(
        animation: _handler,
        builder: (BuildContext context, Widget? child) {
          if (_handler.isLoading)
            return const CircularProgressIndicator.adaptive();
          if (!_handler.gpsServiceEnabled)
            return const Center(
              child: Text('GPS Service not enabled', style: errorTextStyle),
            );
          if (!_handler.gpsPermissionGiven)
            return const Center(
              child: Text('GPS Permissions not given', style: errorTextStyle),
            );

          return child!;
        },
        child: const GasStationSearcherWidget(),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
