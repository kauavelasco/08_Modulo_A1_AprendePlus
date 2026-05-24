import 'package:aprender_plus/models/tema_model.dart';
import 'package:aprender_plus/services/memo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'package:vibration/vibration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {

  List<TemaModel> temas = [];
  TemaModel? temaAtual;
  String itemSelecionado = '';

  StreamSubscription? shakeSubscription;

  final picker = ImagePicker();

  List<String> imagensCustom = [];

  Timer? timer;
  int segundos = 0;
  int minutos = 0;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        segundos++;
      });

      if (segundos == 60) {
        setState(() {
          segundos = 0;
          minutos++;
        });
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  int acertos = 0;
  int erros = 0;

  List<String> cartas = [];

  bool emJogo = false;
  bool cooldown = false;

  bool visiveis = false;

  int contador = 3;

  List<int> selecionadas = [];
  List<int> corretas = [];

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

    // ignore: deprecated_member_use
    shakeSubscription = accelerometerEvents.listen((event) {
      double totalForce = event.x.abs() + event.y.abs() + event.z.abs();

      if (totalForce > 32) {
        embaralharCartas();
      }
    });
  }

  void gerarCartas() {
    List<String> base;

    if (imagensCustom.length == 4) {
      base = imagensCustom;
    } else {
      if (temaAtual == null) return;

      base = temaAtual!.imagens;
    }

    cartas = [
      ...base,
      ...base,
    ];

    cartas.shuffle();
  }

  void embaralharCartas() async {
    if (!emJogo) return;

    setState(() {
      cartas.shuffle();
      selecionadas.clear();
      visiveis = true;
    });

    await Future.delayed(Duration(milliseconds: 800), () {
      if (!mounted) return;

      setState(() {
        visiveis = false;
      });
    });
  }

  void revelar() async {
    setState(() {
      visiveis = true;
    });

    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      visiveis = false;
    });
  }

  void selecionarCarta(int index) async {
    if (!emJogo) return;

    if (selecionadas.contains(index)) return;
    if (corretas.contains(index)) return;

    if (selecionadas.length == 2) return;

    setState(() {
      selecionadas.add(index);
    });

    if (selecionadas.length == 2) {
      int a = selecionadas[0];
      int b = selecionadas[1];

      if (cartas[a] == cartas[b]) {
        setState(() {
          corretas.addAll([a, b]);
          acertos++;
          selecionadas.clear();
        });

        if (corretas.length == cartas.length) {
          mostrarResultado(venceu: true);
        }
      } else {
        erros++;
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 300);
        }
        await Future.delayed(Duration(milliseconds: 800));

        setState(() {
          selecionadas.clear();
        });
      }
    }
  }

  void mostrarResultado({
    bool venceu = false,
  }) {
    stopTimer();

    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (_) {
        return AlertDialog(
          title: Text(
            venceu
              ? 'Vitória'
              : 'Memo Finalizado',
            style: TextStyle(
              color: Color(0xFF1E0053),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tempo: ${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}',
                style: TextStyle(
                  color: Color(0xFF101010),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Acertos: $acertos',
                style: TextStyle(
                  color: Color(0xFF101010),
                  fontSize: 16,
                ),
              ),
              Text(
                'Erros: $erros',
                style: TextStyle(
                  color: Color(0xFF101010),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                finalizarJogo();
              }, 
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF101010),
                ),
              ),
            ),
          ],
        );
      }
    );
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

    startTimer();
    gerarCartas();

    setState(() {
      cooldown = false;
      emJogo = true;

      selecionadas.clear();
      corretas.clear();

      acertos = 0;
      erros = 0;

      visiveis = false;
    });

    revelar();
  }

  void finalizarJogo() {
    stopTimer();
    setState(() {
      emJogo = false;
      cartas.clear();

      selecionadas.clear();
      corretas.clear();

      visiveis = false;

      acertos = 0;
      erros = 0;

      minutos = 0;
      segundos = 0;
    });
  }

  void abrirConfiguracoes() {
    showModalBottomSheet(
      context: context, 
      builder: (_) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Modo Personalizado',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xFF1E0053),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (imagensCustom.length >= 4) return;

                      final XFile? imagem = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (imagem != null) {
                        setState(() {
                          imagensCustom.add(imagem.path);
                        });

                        modalSetState(() {});
                      }
                    },
                    icon: Icon(
                      Icons.photo_library,
                      color: Color(0xFF5A00FB),
                    ),
                    label: Text(
                      'Adicionar foto (${imagensCustom.length}/4)'
                    ),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    children: imagensCustom.map((img) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: kIsWeb
                            ? Image.network(
                                img,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(img),
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  imagensCustom.remove(img);
                                });

                                modalSetState(() {});
                              },
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      }
    );
  }

  Widget cartaWidget(
    int index,
    String? imagem,
  ) {

    bool mostrarFrente = imagem != null;

    return GestureDetector(
      onTap: () {
        selecionarCarta(index);
      },
      child: AnimatedSwitcher(
        duration: Duration(seconds: 1),
        transitionBuilder: (child, animation) {

          final rotate = Tween(
            begin: 3.14,
            end: 0.0,
          ).animate(animation);

          return AnimatedBuilder(
            animation: rotate,
            child: child,
            builder: (_, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(
                  rotate.value,
                ),
                child: child,
              );
            },
          );
        },
        child: Container(
          key: ValueKey(mostrarFrente),
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
          child: mostrarFrente
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imagem.startsWith('assets/')
                      ? Image.asset(
                          imagem,
                          fit: BoxFit.cover,
                        )
                      : kIsWeb
                          ? Image.network(
                              imagem,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(imagem),
                              fit: BoxFit.cover,
                            ),
                )
              : Icon(
                  Icons.question_mark,
                  size: 70,
                  color: Color(0xFF3C00A7),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    
    timer?.cancel();
    shakeSubscription?.cancel();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
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
                            '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}',
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
                            acertos.toString().padLeft(2, '0'),
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
                            erros.toString().padLeft(2, '0'),
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
                          cartaWidget(
                            0,
                            emJogo
                                ? (
                                    visiveis ||
                                    selecionadas.contains(0) ||
                                    corretas.contains(0)
                                  )
                                    ? cartas[0]
                                    : null
                                : null,
                          ),
                          SizedBox(width: 16),
                          cartaWidget(
                            1,
                            emJogo
                                ? (
                                    visiveis ||
                                    selecionadas.contains(1) ||
                                    corretas.contains(1)
                                  )
                                    ? cartas[1]
                                    : null
                                : null,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          cartaWidget(
                            2,
                            emJogo
                                ? (
                                    visiveis ||
                                    selecionadas.contains(2) ||
                                    corretas.contains(2)
                                  )
                                    ? cartas[2]
                                    : null
                                : null,
                          ),
                          SizedBox(width: 16),
                          cartaWidget(
                            3,
                            emJogo
                                ? (
                                    visiveis ||
                                    selecionadas.contains(3) ||
                                    corretas.contains(3)
                                  )
                                    ? cartas[3]
                                    : null
                                : null,
                          ),
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
                          mostrarResultado();
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
                          cartaWidget(
                            4,
                            emJogo
                                ? (
                                    visiveis ||
                                    selecionadas.contains(4) ||
                                    corretas.contains(4)
                                  )
                                    ? cartas[4]
                                    : null
                                : null,
                          ),
                          SizedBox(width: 16),
                          cartaWidget(
                            5,
                            emJogo
                                ? (
                                    visiveis ||
                                    selecionadas.contains(5) ||
                                    corretas.contains(5)
                                  )
                                    ? cartas[5]
                                    : null
                                : null,
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          cartaWidget(
                            6,
                            emJogo
                                ? (
                                    visiveis ||
                                    selecionadas.contains(6) ||
                                    corretas.contains(6)
                                  )
                                    ? cartas[6]
                                    : null
                                : null,
                          ),
                          SizedBox(width: 16),
                          cartaWidget(
                            7,
                            emJogo
                                ? (
                                    visiveis ||
                                    selecionadas.contains(7) ||
                                    corretas.contains(7)
                                  )
                                    ? cartas[7]
                                    : null
                                : null,
                          ),
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
                        ignoring: cooldown ? true : emJogo ? true : false,
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
                IconButton(
                  icon: Icon(
                    Icons.engineering,
                    size: 40,
                    color: Color(0xFF3C00A7),
                  ),
                  onPressed: abrirConfiguracoes,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}