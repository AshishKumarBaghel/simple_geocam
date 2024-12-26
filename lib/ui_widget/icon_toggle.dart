import 'package:flutter/material.dart';

class IconToggle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final bool isActive;

  const IconToggle({super.key, required this.icon, required this.onPressed, this.size = 24, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Icon(
        icon,
        color: isActive ? Colors.blue : Colors.white,
        size: size,
      ),
    );
  }
}
