import 'package:flutter/material.dart';

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;

  static const List<Choice> choices = const <Choice>[
    const Choice(title: 'Expenses for the period', icon: Icons.calendar_today),
    const Choice(title: 'All expenses', icon: Icons.monetization_on),
  ];
}