import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/splash/splash_screen_widget.dart';
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
      debugShowCheckedModeBanner: kDebugMode,
      home: const Material(
        key: ValueKey<String>('splash_screen'),
        child: SplashScreen(),
      ),
    );
  }
}
