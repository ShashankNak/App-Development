import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.function,
      required this.color,
      required this.text,
      required this.borderColor});
  final Function function;
  final Color borderColor;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        backgroundColor: color,
        side: BorderSide(
          color: borderColor,
        ),
        fixedSize: Size(size.width / 1.1, size.height / 20),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    );
  }
}
