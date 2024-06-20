import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/question.dart';
import '../widgets/question_widget.dart';

class QuestionScreen extends StatefulWidget {
  final List<Question> questions;

  QuestionScreen({super.key, required this.questions}) {
    questions.shuffle(); // Shuffle the questions list
  }

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> remainingQuestions = [];
  int currentQuestionIndex = 0;
  Color blue = Color.fromARGB(255, 32, 67, 224);
  Color darkBlue = Color(0xff3442af);
  Color bgColor = Color(0xffe4ecfa);
  Color lightGray = Color(0xffb8c6a6);
  @override
  void initState() {
    super.initState();
    remainingQuestions = List.from(widget.questions);
    displayNextQuestion();
  }

  void displayNextQuestion() {
    if (remainingQuestions.isEmpty) {
      // Navigate to results screen or handle the end of the game
      Navigator.of(context).pushReplacementNamed('/results');
      return;
    }

    setState(() {
      currentQuestionIndex = 0;
    });
  }

  void handleAnswer(String word, bool isCorrect) {
    // if (!isCorrect) {

    // }
    setState(() {
      remainingQuestions.removeWhere((q) => q.word == word);
    });
    Future.delayed(const Duration(seconds: 2), () {
      displayNextQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (remainingQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Match Words with Images'),
        ),
        body: const Center(child: Text('No more questions')),
      );
    }

    Question currentQuestion = remainingQuestions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Words with Images'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<GameState>(
              builder: (context, gameState, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Correct: ${gameState.correctAnswers}'),
                    Text('Errors: ${gameState.wrongAttempts}'),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: QuestionWidget(
                question: currentQuestion,
                allQuestions: widget.questions,
                onAnswer: handleAnswer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
