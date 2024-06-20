import 'package:flutter/material.dart';
import '../models/question.dart';

class QuestionCard extends StatelessWidget {
  final bool showCard;
  final Animation<double> animation;
  final Question question;

  QuestionCard({
    required this.showCard,
    required this.animation,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: showCard ? 15 : -400,
      left: 20,
      right: 20,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 700),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: Card(
          key: ValueKey<String>(question.word),
          shadowColor: Colors.grey.shade50,
          elevation: 10,
          margin: EdgeInsets.all(5),
          color: Colors.grey.shade700,
          child: Container(
            height: 100,
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Center(
                  child: Text(
                    question.word,
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
