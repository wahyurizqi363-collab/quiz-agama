import 'package:flutter/material.dart';

class Question {
  final String text;
  final List<String> options;
  final int answer; // index jawaban benar
  final String explanation;

  const Question(this.text, this.options, this.answer, this.explanation);
}

class Category {
  final String name;
  final IconData icon;
  final List<Question> questions;

  const Category(this.name, this.icon, this.questions);
}
