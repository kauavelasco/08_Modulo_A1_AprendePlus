import 'package:aprender_plus/models/questao_model.dart';
import 'package:flutter/material.dart';

class RelScreen extends StatefulWidget {
  final QuestaoModel questao;
  final VoidCallback onNext;
  final Function(int) onScore;
  final VoidCallback onFinish;
  const RelScreen({super.key, required this.questao, required this.onNext, required this.onScore, required this.onFinish});

  @override
  State<RelScreen> createState() => _RelScreenState();
}

class _RelScreenState extends State<RelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}