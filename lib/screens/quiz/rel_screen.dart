import 'package:aprender_plus/models/questao_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RelScreen extends StatefulWidget {
  final QuestaoModel questao;
  final VoidCallback onNext;
  final Function(int) onScore;
  final VoidCallback onFinish;

  const RelScreen({
    super.key,
    required this.questao,
    required this.onNext,
    required this.onScore,
    required this.onFinish,
  });

  @override
  State<RelScreen> createState() => _RelScreenState();
}

class _RelScreenState extends State<RelScreen> {

  Map<String, String> respostas = {};

  late List<dynamic> pares;
  late List<dynamic> paresEmbaralhados;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    carregarQuestao();
  }

  @override
  void didUpdateWidget(covariant RelScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.questao.id != widget.questao.id) {
      carregarQuestao();
    } 
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void carregarQuestao() {
    respostas = {};
    pares = widget.questao.pares!;
    paresEmbaralhados = List.from(pares);
    paresEmbaralhados.shuffle();
  }

  @override
  Widget build(BuildContext context) {
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
      SizedBox(height: 100),
      Row(
        children: pares.map((par) {
          final bool jaFoiUsado = respostas.containsValue(
            par['termo'],
          );
          return Expanded(
            child: Center(
              child: jaFoiUsado
                  ? SizedBox()
                  : Draggable<String>(
                      data: par['termo'],
                      feedback: Material(
                        color: Colors.transparent,
                        child: Text(
                          par['termo'],
                          style: TextStyle(
                            color: Color(0xFF3C00A7),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: Text(
                          par['termo'],
                          style: TextStyle(
                            color: Color(0xFF3C00A7),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      child: Text(
                        par['termo'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF3C00A7),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: paresEmbaralhados.map((par) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: DragTarget<String>(
                      onWillAcceptWithDetails: (data) {
                        return respostas[par['conceito']] == null;
                      },
                      onAcceptWithDetails: (data) {
                        setState(() {
                          respostas[par['conceito']] = data.data;
                        });
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          height: 200,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF101010),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                par['conceito'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF3C00A7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                respostas[par['conceito']] ?? '',
                                style: TextStyle(
                                  color: Color(0xFF1E0053),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  onPressed: () {

                    if (respostas.length < pares.length) return;

                    int acertos = 0;

                    for (var par in pares) {
                      if (respostas[par['conceito']] == par['termo']) {
                        acertos++;
                      }
                    }

                    if (acertos == pares.length) {
                      widget.onScore(
                        widget.questao.peso
                      );
                    }

                    widget.onNext();
                  },
                  child: Text(
                    'Responder',
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