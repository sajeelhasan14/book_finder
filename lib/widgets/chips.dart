import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String text;
  final bool purple;
  final double size;
  const ChipWidget({
    super.key,
    required this.text,
    this.purple = true,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: purple ? Colors.deepPurple : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          color: purple ? Colors.white : Colors.black,
          fontWeight: purple ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
