import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const AppButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color = Colors.yellow});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      child: Text(text),
    );
  }
}
