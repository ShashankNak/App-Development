import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final VoidCallback selectHandler;
  final String answerText;

  const Answer(this.selectHandler, this.answerText, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 73, 95, 222),
            shadowColor: const Color.fromARGB(255, 28, 36, 83),
          ),
          onPressed: selectHandler,
          child: Text(answerText)),
    );
  }
}
