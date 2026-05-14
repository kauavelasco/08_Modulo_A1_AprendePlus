import 'package:aprender_plus/models/questao_model.dart';
import 'package:flutter/material.dart';

class MeScreen extends StatefulWidget {
  final QuestaoModel questao;
  final VoidCallback onNext;
  final Function(int) onScore;
  final VoidCallback onFinish;
  const MeScreen({super.key, required this.questao, required this.onNext, required this.onScore, required this.onFinish});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}