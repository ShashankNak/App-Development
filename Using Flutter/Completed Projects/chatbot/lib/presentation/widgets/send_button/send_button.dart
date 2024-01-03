import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.send, required this.icon});
  final Function() send;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialButton(
      color: Theme.of(context).colorScheme.onSecondary,
      colorBrightness: Brightness.light,
      height: size.shortestSide / 8,
      minWidth: size.shortestSide / 8,
      shape: const CircleBorder(),
      onPressed: send,
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
