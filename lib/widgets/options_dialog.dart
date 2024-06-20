import 'package:flutter/material.dart';
import '../models/question.dart';

class OptionsDialog extends StatelessWidget {
  final bool showDialog;
  final bool hideDialog;
  final List<String> imageOptions;
  final String? selectedImagePath;
  final Question question;
  final Function(String) onImageSelected;

  OptionsDialog({
    required this.showDialog,
    required this.hideDialog,
    required this.imageOptions,
    required this.selectedImagePath,
    required this.question,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      top: hideDialog ? 600 : (showDialog ? 150 : 600),
      left: 20,
      right: 20,
      child: showDialog ? _buildOptionsDialog(context) : SizedBox.shrink(),
    );
  }

  Widget _buildOptionsDialog(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade400,
              offset: Offset(9, 7),
              blurRadius: 10),
          BoxShadow(
              color: Colors.white, offset: Offset(-9, -7), blurRadius: 10),
        ],
        border: Border.all(width: 3, color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(30),
      ),
      width: double.maxFinite,
      height: 400,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: imageOptions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onImageSelected(imageOptions[index]),
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
                  if (selectedImagePath != null)
                    if (imageOptions[index] == question.imagePath &&
                        imageOptions[index] == selectedImagePath)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: const Icon(
                            Icons.star,
                            color: Colors.green,
                            size: 120,
                          ),
                        ),
                      )
                    else if (imageOptions[index] != question.imagePath &&
                        imageOptions[index] == selectedImagePath)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 120,
                          ),
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
}
