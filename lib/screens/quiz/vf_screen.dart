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

  bool? respostaSelecionada;
  bool respondeu = false;

  @override
  Widget build(BuildContext context) {

    final bool correta = widget.questao.correta!;
    final bool verdadeiroSelecionado = respostaSelecionada == true;
    final bool falsoSelecionado = respostaSelecionada == false;

    Color corVerdadeiro = Color(0xFF101010);
    Color corFalso = Color(0xFF101010);

    if (respondeu) {

      if (correta) {
        corVerdadeiro = Color(0xFF3C00A7);
      } else {
        corFalso = Color(0xFF3C00A7);
      }

      if (verdadeiroSelecionado && !correta) {
        corVerdadeiro = Color(0xFF1E0053);
      }

      if (falsoSelecionado && correta) {
        corFalso = Color(0xFF1E0053);
      }

    } else {

      if (verdadeiroSelecionado) {
        corVerdadeiro = Color(0xFF3C00A7);
      }

      if (falsoSelecionado) {
        corFalso = Color(0xFF3C00A7);
      }

    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz My Brain',
          style: TextStyle(
            color: Color(0xFF1E0053),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.questao.pergunta,
              style: TextStyle(
                color: Color(0xFF5A00FB),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 60),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: respondeu ? null : () {
                        setState(() {
                          respostaSelecionada = true;
                        });
                      },
                      child: Text(
                        'Verdadeiro',
                        style: TextStyle(
                          color: corVerdadeiro,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: respondeu ? null : () {
                        setState(() {
                          respostaSelecionada = false;
                        });
                      },
                      child: Text(
                        'Falso',
                        style: TextStyle(
                          color: corFalso,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5A00FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: widget.onFinish,
                  child: Text(
                    'Encerrar',
                    style: TextStyle(
                      color: Color(0xFFFCFCFC),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5A00FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: respostaSelecionada != null ? () {
                    if (!respondeu) {
                      if (respostaSelecionada == correta) {
                        widget.onScore(
                          widget.questao.peso
                        );
                      }
                      setState(() {
                          respondeu = true;
                        });
                    } else {
                      setState(() {
                        respostaSelecionada = null;
                        respondeu = false;
                      });

                      widget.onNext();
                    }
                  } : null, 
                  child: Text(
                     respondeu ? 'Próximo' : 'Responder',
                    style: TextStyle(
                      color: Color(0xFFFCFCFC),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}