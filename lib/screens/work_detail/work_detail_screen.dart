import 'package:book_finder/models/book_work.dart';
import 'package:flutter/material.dart';

class WorkDetailScreen extends StatelessWidget {
  final BookWork work;
  const WorkDetailScreen({required this.work, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          work.title,
          style: TextStyle(
            fontFamily: "Cinzel",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text("by ${work.authors[0]}")],
        ),
      ),
    );
  }
}
