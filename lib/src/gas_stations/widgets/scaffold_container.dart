import 'package:flutter/material.dart';

class ScaffoldContainer extends StatelessWidget {
  const ScaffoldContainer({
    // ignore: unused_element
    super.key,
    required this.builder,
  });
  final WidgetBuilder builder;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: builder(context),
      ),
    );
  }
}
