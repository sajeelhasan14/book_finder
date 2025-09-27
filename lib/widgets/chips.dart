import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String text;
  final bool purple;
  final double size;
  final Function? onTap;
  const ChipWidget({
    super.key,
    required this.text,
    this.purple = true,
    this.size = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null ? () => onTap!() : null,
      child: Container(
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
      ),
    );
  }
}
