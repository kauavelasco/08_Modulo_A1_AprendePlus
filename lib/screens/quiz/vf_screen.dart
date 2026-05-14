import 'package:aprender_plus/models/questao_model.dart';
import 'package:flutter/material.dart';

class VfScreen extends StatefulWidget {
  final QuestaoModel questao;
  final VoidCallback onNext;
  final Function(int) onScore;
  final VoidCallback onFinish;
  const VfScreen({super.key, required this.questao, required this.onNext, required this.onScore, required this.onFinish});

  @override
  State<VfScreen> createState() => _VfScreenState();
}

class _VfScreenState extends State<VfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}