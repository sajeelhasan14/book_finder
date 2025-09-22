// lib/widgets/author_chip.dart
import 'package:flutter/material.dart';

class AuthorChip extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;
  const AuthorChip({super.key, required this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(label: Text(name), onPressed: onTap ?? () {});
  }
}
