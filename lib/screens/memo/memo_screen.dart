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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Spacer(),
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
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}