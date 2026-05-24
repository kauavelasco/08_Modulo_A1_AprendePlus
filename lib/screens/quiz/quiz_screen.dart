import 'package:aprender_plus/models/questao_model.dart';
import 'package:aprender_plus/screens/home/home_screen.dart';
import 'package:aprender_plus/screens/quiz/me_screen.dart';
import 'package:aprender_plus/screens/quiz/rel_screen.dart';
import 'package:aprender_plus/screens/quiz/vf_screen.dart';
import 'package:aprender_plus/services/quiz_service.dart';
import 'package:aprender_plus/services/score_service.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  QuizService service = QuizService();

  List<QuestaoModel> questoes = [];

  bool carregando = true;

  int questaoAtual = 0;

  int score = 0;

  void proximaQuestao() {
    if (questaoAtual < questoes.length - 1) {
      setState(() {
        questaoAtual++;
      });
    } else {
      finalizarQuiz();
    }
  }

  void adicionarScore(int valor) {
    setState(() {
      score+= valor;
    });
  }

  void finalizarQuiz() async {

    await ScoreService.salvarQuiz(score);

    showDialog(
      barrierDismissible: false,
      // ignore: use_build_context_synchronously
      context: context, 
      builder: (_) {
        return AlertDialog(
          title: Text('Quiz Encerrado!'),
          content: Text('Sua pontuação foi: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              }, 
              child: Text('OK'),
            ),
          ],
        );
      }
    );
  }

  void carregarQuestoes() async {
    final resultado = await service.carregarQuestoes();

    setState(() {
      questoes = resultado;
      carregando = false;
    });
  }

  @override
  void initState() {
    super.initState();
    carregarQuestoes();
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (questoes.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text('Sem questões disponíveis'),
        ),
      );
    }

    switch (questoes[questaoAtual].tipo) {
      case "ME":
        return MeScreen(
          questao: questoes[questaoAtual],
          onNext: proximaQuestao,
          onFinish: finalizarQuiz,
          onScore: adicionarScore,
        );
      case "VF":
        return VfScreen(
          questao: questoes[questaoAtual],
          onNext: proximaQuestao,
          onFinish: finalizarQuiz,
          onScore: adicionarScore,
        );
      case "REL":
        return RelScreen(
          questao: questoes[questaoAtual],
          onNext: proximaQuestao,
          onFinish: finalizarQuiz,
          onScore: adicionarScore,
        );
      default:
        return Scaffold(
          body: Center(
            child: Text('Tipo inválido'),
          ),
        );
    }
  }
}