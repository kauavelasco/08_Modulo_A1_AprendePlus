import 'package:aprender_plus/models/tema_model.dart';
import 'package:aprender_plus/services/memo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {

  List<TemaModel> temas = [];
  TemaModel? temaAtual;
  String itemSelecionado = '';

  List<String> cartas = [];

  bool emJogo = false;
  bool cooldown = false;

  int contador = 3;

  final service = MemoService();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    service.carregarDados().then((value) {
      setState(() {
        temas = value.temas;
        temaAtual = temas.first;
        itemSelecionado = temaAtual!.nome;
      });
    });
  }

  void gerarCartas() {
    if (temaAtual == null) return;

    cartas = [
      ...temaAtual!.imagens,
      ...temaAtual!.imagens,
    ];

    cartas.shuffle();
  }

  void iniciarJogo() async {
    if (cooldown) return;

    setState(() {
      cooldown = true;
      contador = 3;
    });

    for (int i = 3; i > 0; i--) {
      setState(() {
        contador = i;
      });

      await Future.delayed(Duration(seconds: 1));
    }

    gerarCartas();

    setState(() {
      cooldown = false;
      emJogo = true;
    });
  }

  void finalizarJogo() {
    setState(() {
      emJogo = false;
      cartas.clear();
    });
  }

  Widget cartaWidget() {
    return Container(
      width: 195,
      height: 195,
      decoration: BoxDecoration(
        color: Color(0xFFFCFCFC),
        border: Border.all(
          color: Color(0xFF3C00A7),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (temaAtual == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MemoCheck',
          style: TextStyle(
            color: Color(0xFF3C00A7),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Tempo: ',
                      style: TextStyle(
                        color: Color(0xFF3C00A7),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 65,
                      decoration: BoxDecoration(
                        color: Color(0xFFFCFCFC),
                        border: Border.all(
                          color: Color(0xFF3C00A7),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '00:00',
                            style: TextStyle(
                              color: Color(0xFF3C00A7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Acertos: ',
                      style: TextStyle(
                        color: Color(0xFF3C00A7),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFFFCFCFC),
                        border: Border.all(
                          color: Color(0xFF3C00A7),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '00',
                            style: TextStyle(
                              color: Color(0xFF3C00A7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Erros: ',
                      style: TextStyle(
                        color: Color(0xFF3C00A7),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 45,
                      decoration: BoxDecoration(
                        color: Color(0xFFFCFCFC),
                        border: Border.all(
                          color: Color(0xFF3C00A7),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '00',
                            style: TextStyle(
                              color: Color(0xFF3C00A7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          cartaWidget(),
                          SizedBox(width: 16),
                          cartaWidget()
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          cartaWidget(),
                          SizedBox(width: 16),
                          cartaWidget()
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3C00A7),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 18),
                      ),
                      onPressed: cooldown ? null : () {
                        if (emJogo) {
                          finalizarJogo();
                        } else {
                          iniciarJogo();
                        }
                      },
                      child: Text(
                        cooldown
                          ? contador.toString()
                          : emJogo
                            ? 'Stop'
                            : 'Start',
                        style: TextStyle(
                          color: Color(0xFFFCFCFC),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          cartaWidget(),
                          SizedBox(width: 16),
                          cartaWidget()
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          cartaWidget(),
                          SizedBox(width: 16),
                          cartaWidget()
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Tema: ',
                      style: TextStyle(
                        color: Color(0xFF3C00A7),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: 400,
                      child: IgnorePointer(
                        ignoring: emJogo,
                        child: DropdownButtonFormField<String>(
                          initialValue: itemSelecionado,
                          dropdownColor: Color(0xFFFCFCFC),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3C00A7),
                              ),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3C00A7),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF3C00A7),
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 4,
                            ),
                          ),
                          items: temas.map((tema) {
                            return DropdownMenuItem(
                              value: tema.nome,
                              child: Text(tema.nome),
                            );
                          }).toList(), 
                          onChanged: (String? value) {
                            setState(() {
                              itemSelecionado = value!;
                        
                              temaAtual = temas.firstWhere((tema) => tema.nome == itemSelecionado);
                            });
                          }
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.engineering,
                  size: 40,
                  color: Color(0xFF3C00A7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}