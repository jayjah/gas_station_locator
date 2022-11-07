import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/permissions/permission_widget.dart';
import 'package:gasstation_locator/src/util/dialogs.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gas station locator',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
          primary: Colors.deepOrangeAccent,
        ),
        useMaterial3: true,
      ),
      home: const Material(child: PermissionWidget()),
    );
  }
}
