
import 'package:flutter/material.dart';

class SubjectChip extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  const SubjectChip({super.key, required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(name), backgroundColor: Colors.grey.shade200);
  }
}
