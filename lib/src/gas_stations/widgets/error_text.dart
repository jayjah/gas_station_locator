import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({
    super.key,
    required this.content,
    this.style = const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  });
  final String content;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        content,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }
}
