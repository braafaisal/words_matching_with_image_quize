import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:word_image_matching_game/game_logic.dart';
import '../models/question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;
  final List<Question> allQuestions;
  final Function(String, bool) onAnswer;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.allQuestions,
    required this.onAnswer,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>
    with SingleTickerProviderStateMixin {
  Color? _color;
  bool _isLocked = false;
  bool _showCard = false;
  bool _showDialog = false;
  bool _hideDialog = false;
  bool _canInteract = true;
  // Color backGroundColor = Color.fromARGB(255, 241, 242, 246);
  // Color darkShadowColor = Color.fromARGB(255, 218, 223, 243);
  // Color textColor = Color.fromARGB(255, 112, 112, 112);
  // Color secondLightColor = Color.fromARGB(255, 184, 236, 237);
  // Color secondDarkColor = Color.fromARGB(255, 55, 200, 223);
  Color blue = Color.fromARGB(255, 32, 67, 224);
  Color darkBlue = Color(0xff3442af);
  Color bgColor = Color(0xffe4ecfa);
  Color lightGray = Color(0xffb8c6a6);

  String? _selectedImagePath;
  late List<String> imageOptions;
  final GameLogic _gameLogic = GameLogic();
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _initializeImageOptions();
    // _animationController.forward();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _gameLogic.speakWord(widget.question.word);

        _showCard = true;
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          _showDialog = true;
        });
      });
    });
  }

  void _initializeImageOptions() {
    _gameLogic.initializeImageOptions(widget.question, widget.allQuestions,
        (options) {
      setState(() {
        imageOptions = options;
      });
    });
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _initializeImageOptions();
      // _gameLogic.speakWord(widget.question.word);
      setState(() {
        _showCard = false;
        _showDialog = false;
        _hideDialog = false;
        _canInteract = true;
        _selectedImagePath = null;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _gameLogic.speakWord(widget.question.word);
          _showCard = true;
        });
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _showDialog = true;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // backgroundColor: Colors.indigo.shade400,
      // ),
      // backgroundColor: Colors.white,
      // backgroundColor: blue,
      body: Stack(
        children: [
          // AnimatedPositioned(
          //   duration: Duration(milliseconds: 500),
          //   curve: Curves.easeInOut,
          //   top: _showCard ? 20 : -200,
          //   left: 20,
          //   right: 20,
          //   child: Card(
          //     margin: EdgeInsets.all(8),
          //     color: _color ?? Colors.blue,
          //     child: ListTile(
          //       title: Text(widget.question.word),
          //       onTap: null,
          //     ),
          //   ),
          // ),
          // AnimatedPositioned(
          //   duration: Duration(milliseconds: 500),
          //   curve: Curves.easeInOut,
          //   top: _hideDialog ? 600 : (_showDialog ? 100 : 600),
          //   left: 20,
          //   right: 20,
          //   child: _showDialog
          //       ? _buildOptionsDialog(context, imageOptions)
          //       : SizedBox.shrink(),
          // ),

          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            top: _showCard ? 15 : -400,
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
                key: ValueKey<String>(widget.question.word),
                shadowColor: Colors.grey.shade50,
                elevation: 10,
                margin: EdgeInsets.all(5),
                color: _color ?? Colors.grey.shade700,
                child: Container(
                  height: 100,
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return ScaleTransition(
                          scale: _animation,
                          child: child,
                        );
                      },
                      child: Center(
                          child: Text(
                        widget.question.word,
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(seconds: 1),
            curve: Curves.easeInOut,
            // top: _hideDialog ? 600 : (_showDialog ? 250 : 600),
            top: _hideDialog ? 600 : (_showDialog ? 150 : 600),
            left: 20,
            right: 20,
            child: _showDialog
                ? _buildOptionsDialog(context, imageOptions)
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsDialog(BuildContext context, List<String> imageOptions) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // stops: [0, 6],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            darkBlue,
            Colors.lightBlue,
            blue,
          ],
        ),
        border: Border.all(width: 3, color: Colors.grey.shade50),
        borderRadius: BorderRadius.circular(30),
      ),
      // decoration: BoxDecoration(
      //     gradient:  LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         colors: [
      //       Colors.lightBlue,
      //    blue,
      //      darkBlue,
      //     ])
      //     // color: Colors.amber.shade100,
      //     // color: backGroundColor,
      //     // boxShadow: [
      //     //   BoxShadow(
      //     //       color: darkShadowColor, offset: Offset(9, 7), blurRadius: 10),
      //     //   BoxShadow(
      //     //       color: lightShadowColor, offset: Offset(9, 7), blurRadius: 10),
      //     // ],
      //     // border: Border.all(width: 3, color: Colors.grey.shade600),
      //     // borderRadius: BorderRadius.circular(30),
      //     ),
      width: double.maxFinite,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: imageOptions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: _canInteract
                  ? () => _handleSelection(imageOptions[index])
                  : null,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(child: Image.asset(imageOptions[index])),
                  ),
                  if (_selectedImagePath != null)
                    if (imageOptions[index] == widget.question.imagePath &&
                        imageOptions[index] == _selectedImagePath)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.green,
                          size: 50,
                        ),
                      )
                    else if (imageOptions[index] != widget.question.imagePath &&
                        imageOptions[index] == _selectedImagePath)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 50,
                        ),
                      ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleSelection(String selectedImagePath) {
    _gameLogic.handleSelection(selectedImagePath, widget.question, context,
        (isCorrect, color) {
      setState(() {
        _isLocked = true;
        _canInteract = false;
        _selectedImagePath = selectedImagePath;
        _color = color;
        if (isCorrect) {
          _animationController.repeat(
            reverse: true,
            // period: Duration(
            //   milliseconds: 300,
            // ),
          );
        }
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _hideDialog = true;
          });

          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              _isLocked = false;
              _color = null;
              _showDialog = false;
              _hideDialog = false;
              _canInteract = true;
              _selectedImagePath = null;
            });

            widget.onAnswer(widget.question.word, isCorrect);
            if (isCorrect) {
              _animationController.stop();
            }
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _gameLogic.flutterTts.stop();
    _animationController.dispose();
    super.dispose();
  }
}











// import 'package:flutter/material.dart';
// import 'package:word_image_matching_game/game_logic.dart';
// import '../models/question.dart';

// class QuestionWidget extends StatefulWidget {
//   final Question question;
//   final List<Question> allQuestions;
//   final Function(String, bool) onAnswer;

//   QuestionWidget({
//     required this.question,
//     required this.allQuestions,
//     required this.onAnswer,
//   });

//   @override
//   _QuestionWidgetState createState() => _QuestionWidgetState();
// }

// class _QuestionWidgetState extends State<QuestionWidget> {
//   Color? _color;
//   bool _isLocked = false;
//   bool _showCard = false;
//   bool _showDialog = false;
//   bool _hideDialog = false;
//   bool _canInteract = true;
//   String? _selectedImagePath;
//   late List<String> imageOptions;
//   final GameLogic _gameLogic = GameLogic();

//   @override
//   void initState() {
//     super.initState();
//     _initializeImageOptions();
//     _gameLogic.speakWord(widget.question.word);
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         _showCard = true;
//       });
//       Future.delayed(Duration(seconds: 1), () {
//         setState(() {
//           _showDialog = true;
//         });
//       });
//     });
//   }

//   void _initializeImageOptions() {
//     _gameLogic.initializeImageOptions(widget.question, widget.allQuestions,
//         (options) {
//       setState(() {
//         imageOptions = options;
//       });
//     });
//   }

//   @override
//   void didUpdateWidget(covariant QuestionWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.question != widget.question) {
//       _initializeImageOptions();
//       _gameLogic.speakWord(widget.question.word);
//       setState(() {
//         _showCard = false;
//         _showDialog = false;
//         _hideDialog = false;
//         _canInteract = true;
//         _selectedImagePath = null;
//       });
//       Future.delayed(Duration(milliseconds: 500), () {
//         setState(() {
//           _showCard = true;
//         });
//         Future.delayed(Duration(seconds: 1), () {
//           setState(() {
//             _showDialog = true;
//           });
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           AnimatedPositioned(
//             duration: Duration(milliseconds: 500),
//             curve: Curves.easeInOut,
//             top: _showCard ? 20 : -200,
//             left: 20,
//             right: 20,
//             child: Card(
//               margin: EdgeInsets.all(8),
//               color: _color ?? Colors.blue,
//               child: ListTile(
//                 title: Text(widget.question.word),
//                 onTap: null,
//               ),
//             ),
//           ),
//           AnimatedPositioned(
//             duration: Duration(seconds: 1),
//             curve: Curves.easeInOut,
//             top: _hideDialog ? 600 : (_showDialog ? 100 : 600),
//             left: 20,
//             right: 20,
//             child: _showDialog
//                 ? _buildOptionsDialog(context, imageOptions)
//                 : SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOptionsDialog(BuildContext context, List<String> imageOptions) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.amber.shade100,
//         border: Border.all(width: 6, color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       width: double.maxFinite,
//       height: 400,
//       child: Padding(
//         padding: const EdgeInsets.all(2.0),
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//           ),
//           itemCount: imageOptions.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               onTap: _canInteract
//                   ? () => _handleSelection(imageOptions[index])
//                   : null,
//               child: Stack(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       border: Border.all(width: 5, color: Colors.white),
//                       color: Colors.indigo,
//                       borderRadius: BorderRadius.circular(100),
//                     ),
//                     child: Center(child: Image.asset(imageOptions[index])),
//                   ),
//                   if (_selectedImagePath != null)
//                     if (imageOptions[index] == widget.question.imagePath &&
//                         imageOptions[index] == _selectedImagePath)
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.8),
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.star,
//                             color: Colors.green,
//                             size: 120,
//                           ),
//                         ),
//                       )
//                     else if (imageOptions[index] != widget.question.imagePath &&
//                         imageOptions[index] == _selectedImagePath)
//                       Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.7),
//                           borderRadius: BorderRadius.circular(100),
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.close,
//                             color: Colors.red,
//                             size: 120,
//                           ),
//                         ),
//                       ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void _handleSelection(String selectedImagePath) {
//     _gameLogic.handleSelection(selectedImagePath, widget.question, context,
//         (isCorrect, color) {
//       setState(() {
//         _isLocked = true;
//         _canInteract = false;
//         _selectedImagePath = selectedImagePath;
//         _color = color;

//         Future.delayed(Duration(seconds: 2), () {
//           setState(() {
//             _hideDialog = true;
//           });

//           Future.delayed(Duration(milliseconds: 500), () {
//             setState(() {
//               _isLocked = false;
//               _color = null;
//               _showDialog = false;
//               _hideDialog = false;
//               _canInteract = true;
//               _selectedImagePath = null;
//             });

//             widget.onAnswer(widget.question.word, isCorrect);
//           });
//         });
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _gameLogic.flutterTts.stop();
//     super.dispose();
//   }
// }
