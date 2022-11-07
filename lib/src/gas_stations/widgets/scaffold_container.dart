import 'package:flutter/material.dart';

class ScaffoldContainer extends StatelessWidget {
  const ScaffoldContainer({
    // ignore: unused_element
    super.key,
    required this.builder,
    this.bottomNavigation,
  });
  final WidgetBuilder builder;
  final Widget? bottomNavigation;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: bottomNavigation,
        body: builder(context),
      ),
    );
  }
}
