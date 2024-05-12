import 'package:flutter/material.dart';

class WordButton extends StatelessWidget {
  const WordButton({super.key, required this.buttonTitle, this.onPressed});

  final VoidCallback? onPressed;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3.0,
        backgroundColor: Color(0xFF1089ff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4.0),
      ),
      onPressed: onPressed,
      child: Text(
        buttonTitle,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 27,
        ),
      ),
    );
  }
}
