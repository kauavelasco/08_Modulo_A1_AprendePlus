import 'package:flutter/material.dart';

class GeniusScreen extends StatefulWidget {
  const GeniusScreen({super.key});

  @override
  State<GeniusScreen> createState() => _GeniusScreenState();
}

class _GeniusScreenState extends State<GeniusScreen> {
  String itemSelecionado = "Português";
  final List<String> options = ['Português', 'English', 'Español'];

  bool emJogo = false;
  int score = 0;
  int nivel = 1;
  

  void adicionarPonto(int ponto) {
    setState(() {
      score += ponto;
    });
  }

  void proximoNivel() {
    setState(() {
      nivel++;
    });
  }

  void resetGame() async {
    setState(() {
      emJogo = false;
      nivel = 1;
      score = 0;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      emJogo = true;
    });
  }

  void finalizarJogo() {
    setState(() {
      emJogo = false;
      score = 0;
    });
  }

  Widget colorButton({
    required Color cor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 30,
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Genius Play',
          style: TextStyle(
            color: Color(0xFF3C00A7),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 130, 
            child: IgnorePointer(
              ignoring: emJogo ? true : false,
              child: DropdownButtonFormField<String>(
                initialValue: itemSelecionado,
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3C00A7)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3C00A7)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3C00A7), width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                items: options.map((String opcao) {
                  return DropdownMenuItem<String>(
                    value: opcao,
                    child: Text(
                      opcao,
                      style: TextStyle(color: Color(0xFF3C00A7)),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    itemSelecionado = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione uma opção';
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nível: $nivel',
                  style: TextStyle(
                    color: Color(0xFF3C00A7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '00:00',
                  style: TextStyle(
                    color: Color(0xFF3C00A7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    colorButton(
                      cor: Colors.green, 
                      onTap: () {}
                    ),
                    colorButton(
                      cor: Colors.yellow, 
                      onTap: () {}
                    )
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3C00A7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: emJogo ? () {
                      finalizarJogo();
                      setState(() {
                        emJogo = false;
                      });
                    } : () {
                      setState(() {
                        emJogo = true;
                      });
                    }, 
                    child: Text(
                      emJogo ? 'Stop' : 'Start',
                      style: TextStyle(
                        color: Color(0xFFFCFCFC),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    colorButton(
                      cor: Colors.orange,
                      onTap: () {}
                    ),
                    colorButton(
                      cor: Colors.blue,
                      onTap: () {}
                    ),
                  ],
                ),
                SizedBox(height: 20),
                colorButton(
                  cor: Colors.red,
                  onTap: () {}
                ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Text(
                  'Score:   ',
                  style: TextStyle(
                    color: Color(0xFF3C00A7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  score.toString().padLeft(4, '0'),
                  style: TextStyle(
                    color: Color(0xFF3C00A7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5A00FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: emJogo ? resetGame : null,
                  child: Text(
                    'Restart',
                    style: TextStyle(
                      color: Color(0xFFFCFCFC),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}