import 'package:aprender_plus/models/questao_model.dart';
import 'package:flutter/material.dart';

class MeScreen extends StatefulWidget {
  final QuestaoModel questao;
  final VoidCallback onNext;
  final Function(int) onScore;
  final VoidCallback onFinish;
  const MeScreen({
    super.key,
    required this.questao,
    required this.onNext,
    required this.onScore,
    required this.onFinish,
  });

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  int? selectedIndex;
  bool respondeu = false;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> alternativas = widget.questao.alternativas!;

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
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: alternativas.length,
                itemBuilder: (context, index) {
                  final letra = alternativas[index]['letra'];
                  final texto = alternativas[index]['texto'];
                  final bool isCorrect = alternativas[index]['correta'] == true;
                  final bool isSelected = selectedIndex == index;

                  Color cor = Color(0xFF101010);

                  if (respondeu) {
                    if (isCorrect) {
                      cor = Color(0xFF3C00A7);
                    } else if (isSelected) {
                      cor = Color(0xFF1E0053);
                    }
                  } else if (isSelected) {
                    cor = Color(0xFF3C00A7);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: GestureDetector(
                      onTap: respondeu
                          ? null
                          : () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                      child: Row(
                        children: [
                          Text(
                            '$letra)',
                            style: TextStyle(
                              color: cor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            texto,
                            style: TextStyle(
                              color: cor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                  onPressed: selectedIndex != null
                      ? () {
                          if (!respondeu) {
                            if (alternativas[selectedIndex!]['correta'] == true) {
                              widget.onScore(widget.questao.peso);
                            }

                            setState(() {
                              respondeu = true;
                            });
                          } else {

                            setState(() {
                              selectedIndex = null;
                              respondeu = false;
                            });
                            widget.onNext();
                          }
                        }
                      : null,
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