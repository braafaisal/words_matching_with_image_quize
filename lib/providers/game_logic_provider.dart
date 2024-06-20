import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/question.dart';

class GameLogic extends ChangeNotifier {
  FlutterTts flutterTts = FlutterTts();
  late List<String> imageOptions = [];

  void initializeImageOptions(Question question, List<Question> allQuestions, Function(List<String>) callback) {
    List<String> options = [question.imagePath];
    allQuestions.shuffle();
    for (var q in allQuestions) {
      if (options.length < 4 && !options.contains(q.imagePath)) {
        options.add(q.imagePath);
      }
    }
    options.shuffle();
    callback(options);
  }

  void speakWord(String word) {
    flutterTts.speak(word);
  }

  void handleSelection(String selectedImagePath, Question question, BuildContext context, Function(bool, Color) callback) {
    bool isCorrect = selectedImagePath == question.imagePath;
    Color color = isCorrect ? Colors.green : Colors.red;
    callback(isCorrect, color);
    notifyListeners();
  }
}
