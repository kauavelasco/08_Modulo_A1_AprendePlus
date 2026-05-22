import 'dart:math';
import 'package:aprender_plus/models/cores_model.dart';
import 'package:aprender_plus/models/idioma_model.dart';
import 'package:aprender_plus/services/genius_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';

class GeniusScreen extends StatefulWidget {
  const GeniusScreen({super.key});

  @override
  State<GeniusScreen> createState() => _GeniusScreenState();
}

class _GeniusScreenState extends State<GeniusScreen> {

  String itemSelecionado = "";

  bool emJogo = false;
  int score = 0;
  int nivel = 1;

  IdiomaModel? idiomaAtual;
  List<IdiomaModel> idiomas = [];

  final service = GeniusService();
  final player = AudioPlayer();

  Future<void> tocarAudio(String path) async {

  try {

    await player.play(
      AssetSource(path),
    );

  } catch (e) {

    print(e);

  }
}

  Timer? timer;
  int segundos = 0;
  int minutos = 0;

  List<int> sequenciaJogo = [];
  List<int> sequenciaJogador = [];
  int? corAtiva;

  bool mostrandoSequencia = false;

  void adicionarNovaCor() {
    int numeroAleatorio = Random().nextInt(
      idiomaAtual!.cores.length
    );

    sequenciaJogo.add(numeroAleatorio);
    print(sequenciaJogo);
  }

  Future<void> mostrarSequencia() async {

    if (mostrandoSequencia) return;

    mostrandoSequencia = true;

    final cores = idiomaAtual!.cores;

    for (int indice in sequenciaJogo) {
      setState(() {
        corAtiva = indice;
      });

      tocarAudio(
        cores[indice].audio,
      );

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        corAtiva = null;
      });

      await Future.delayed(Duration(milliseconds: 300));
    }
    mostrandoSequencia = false;
  }

  void jogar(int indice) async {
    if (mostrandoSequencia) return;

    final cores = idiomaAtual!.cores;

    setState(() {
      corAtiva = indice;
    });

    tocarAudio(
      cores[indice].audio,
    );

    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      corAtiva = null;
    });

    sequenciaJogador.add(indice);
    print(sequenciaJogador);
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        segundos++;

        if (segundos == 60) {
          segundos = 0;
          minutos++;
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      minutos = 0;
      segundos = 0;
    });
  }

  void resetTimer() {
    timer?.cancel();

    setState(() {
      minutos = 0;
      segundos = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    service.carregarDados().then((value) {

      if (value.idiomas.isEmpty) return;

      final locale = PlatformDispatcher.instance.locale.languageCode;

      IdiomaModel idiomaSistema;

      if (locale == 'en') {
        idiomaSistema = value.idiomas[1];
      } else if (locale == 'es') {
        idiomaSistema = value.idiomas[2];
      } else {
        idiomaSistema = value.idiomas[0];
      }
      setState(() {
        idiomas = value.idiomas;

        idiomaAtual = idiomaSistema;

        itemSelecionado = idiomaSistema.nome;
      });
    }).catchError((e) {
      print(e);
    });
  }

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
      corAtiva = null;
    });
    resetTimer();

    await Future.delayed(
      Duration(seconds: 2),
    );

    setState(() {
      emJogo = true;
    });
    startTimer();
  }

  void finalizarJogo() {
    setState(() {
      emJogo = false;
      score = 0;
      corAtiva = null;
    });
    stopTimer();
  }

  Color pegarCor(String id) {
    switch (id) {
      case 'yellow':
        return Colors.yellow;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;

      default:
        return Colors.black;
    }
  }

  Widget colorButton({
    required int indice,
    required Color cor,
    required VoidCallback onTap,
  }) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 60,
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Center(
          child: Container(
            width: 100,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: corAtiva == indice
            ? [
              BoxShadow(
                color: Color(0xFFFCFCFC),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ]
            : [],
            ),
          ),
        ),
      ),
    );
  }

  Widget painelCores(List<CoresModel> cores) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            colorButton(
              indice: 0,
              cor: pegarCor(cores[0].id),
              onTap: () {
                jogar(0);
              },
            ),
            colorButton(
              indice: 1,
              cor: pegarCor(cores[1].id),
              onTap: () {
                jogar(1);
              },
            ),
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
            onPressed: emJogo
                ? () {
                    finalizarJogo();
                  }
                : () {
                    setState(() {
                      emJogo = true;
                    });
                    resetTimer();
                    sequenciaJogo.clear();
                    sequenciaJogador.clear();

                    adicionarNovaCor();
                    mostrarSequencia();
                    startTimer();
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
              indice: 2,
              cor: pegarCor(cores[2].id),
              onTap: () {
                jogar(2);
              },
            ),
            colorButton(
              indice: 3,
              cor: pegarCor(cores[3].id),
              onTap: () {
                jogar(3);
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        colorButton(
          indice: 4,
          cor: pegarCor(cores[4].id),
          onTap: () {
            jogar(4);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (idiomaAtual == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final cores = idiomaAtual!.cores;

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
              ignoring: emJogo,
              child: DropdownButtonFormField<String>(
                initialValue: itemSelecionado,
                dropdownColor: Colors.white,
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
                    horizontal: 8,
                    vertical: 4,
                  ),
                ),
                items: idiomas.map((idioma) {
                  return DropdownMenuItem<String>(
                    value: idioma.nome,
                    child: Text(
                      idioma.nome,
                      style: TextStyle(
                        color: Color(0xFF3C00A7),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    itemSelecionado = value!;
                  });
                  idiomaAtual = idiomas.firstWhere(
                    (idioma) =>
                        idioma.nome == itemSelecionado,
                  );
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
                  '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Color(0xFF3C00A7),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            painelCores(cores),
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
                  onPressed: emJogo
                      ? resetGame
                      : null,
                  child: Text(
                    'Restart',
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