import 'package:flutter/material.dart';

class CameraButton extends StatefulWidget {
  final double size; // Size of the outer button (diameter)
  final VoidCallback onPressed; // Action when the button is pressed
  final bool isWorking;
  final Color color;

  const CameraButton({
    super.key,
    required this.size,
    required this.onPressed,
    this.isWorking = false,
    this.color = Colors.blue,
  });

  @override
  _CameraButtonState createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _innerCircleScale;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    // Define a Tween to scale the inner circle from 0.8 -> 0.6 of its parent size
    _innerCircleScale = Tween<double>(begin: 0.8, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  // When user presses down:
  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  // When user lifts finger:
  void _onTapUp(TapUpDetails details) {
    _controller.reverse(); // Return to original size
    widget.onPressed(); // Trigger the onPressed callback
  }

  // If the touch is canceled (e.g., user drags finger away):
  void _onTapCancel() {
    _controller.reverse(); // Return to original size
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown, // Called when a pointer that might cause a tap has contacted the screen.
      onTapUp: _onTapUp, // Called when a pointer that will trigger a tap has stopped contacting the screen.
      onTapCancel: _onTapCancel, // Called when the gesture is canceled.
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Calculate the inner circle’s size based on the current animation value.
          final double innerSize = widget.size * _innerCircleScale.value;

          return Container(
            width: widget.size,
            // Outer circle diameter
            height: widget.size,
            margin: const EdgeInsets.only(left: 1, right: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white, // Outer border color
                width: 2.5,
              ),
              color: Colors.transparent, // Outer circle is transparent
            ),
            child: Center(
              child: (widget.isWorking)
                  ? CircularProgressIndicator()
                  : Container(
                      width: innerSize * 1.05,
                      height: innerSize * 1.05,
                      decoration: BoxDecoration(
                        color: widget.color, // Inner circle color
                        shape: BoxShape.circle,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
