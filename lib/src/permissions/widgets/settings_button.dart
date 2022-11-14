import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    super.key,
    required this.content,
  });
  final String content;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const <Widget>[
        Center(
          child: Text(
            'GPS Permissions not given',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        TextButton(
          onPressed: AppSettings.openLocationSettings,
          child: Text('Settings'),
        ),
      ],
    );
  }
}
