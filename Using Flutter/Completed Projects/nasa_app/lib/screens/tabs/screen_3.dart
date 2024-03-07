import 'package:flutter/material.dart';

class Screen3 extends StatelessWidget {
  const Screen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Screen3",
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(color: Colors.white),
      ),
    );
  }
}
