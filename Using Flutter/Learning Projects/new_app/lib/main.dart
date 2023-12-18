import 'package:flutter/material.dart';

import './quiz.dart';
import './result.dart';

void main() {
  runApp(const MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  final questions = const [
    {
      'questionText': 'What\'s your favorite color?',
      'answerText': [
        {'Text': 'Black', 'Score': 10},
        {'Text': 'Purple', 'Score': 6},
        {'Text': 'Red', 'Score': 5},
        {'Text': 'Orange', 'Score': 3}
      ]
    },
    {
      'questionText': 'What\'s your favorite animal?',
      'answerText': [
        {'Text': 'Lion', 'Score': 10},
        {'Text': 'Elephant', 'Score': 6},
        {'Text': 'Zebra', 'Score': 5},
        {'Text': 'Tiger', 'Score': 3}
      ]
    },
    {
      'questionText': 'What\'s your favorite food?',
      'answerText': [
        {'Text': 'Paneer Tikka', 'Score': 10},
        {'Text': 'Biryani', 'Score': 6},
        {'Text': 'Protein Shake', 'Score': 5},
        {'Text': 'Dhokla', 'Score': 3}
      ]
    },
  ];

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex += 1;
    });
    // ignore: avoid_print
    print(_questionIndex);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'First Application',
          ),
          backgroundColor: const Color.fromARGB(255, 73, 95, 222),
        ),
        body: _questionIndex < questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questions: questions,
                questionIndex: _questionIndex)
            : Result(_totalScore, _resetQuiz),
      ),
    );
  }
}
