import 'package:flutter/material.dart';

class CameraButton extends StatelessWidget {
  final double size; // Size of the button
  final VoidCallback onPressed; // Action when the button is pressed

  // Constructor to accept size and onPressed action
  const CameraButton({super.key, required this.size, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size, // Diameter of the circle
        height: size, // Diameter of the circle
        margin: const EdgeInsets.only(left: 5,right: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white, // Border color
            width: 1.5, // Border width
          ),
          color: Colors.transparent, // Transparent inner circle
        ),
        child: Center(
          child: Container(
            width: size * 0.8,
            height: size * 0.8,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
