import 'package:flutter/material.dart';
import 'package:gasstation_locator/src/permissions/permission_widget.dart';
import 'package:rive/rive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreenAfter(duration: const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'assets/pump-gas.riv',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  void _navigateToNextScreenAfter({required Duration duration}) =>
      Future<void>.delayed(
        duration,
        () {
          Navigator.of(context).push(
            MaterialPageRoute<Material>(
              builder: (BuildContext context) =>
                  const Material(child: PermissionWidget()),
            ),
          );
        },
      );
}
