import 'package:aprender_plus/screens/genius/genius_screen.dart';
import 'package:aprender_plus/screens/quiz/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Color(0xFF3C00A7),
                        ),
                      ),
                      child: Icon(
                        Icons.person_2_outlined,
                        size: 120,
                        color: Color(0xFF3C00A7),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Color(0xFF101010),
                    ),
                    SizedBox(height: 5),
                    ListTile(
                      title: Text(
                        'Home',
                        style: TextStyle(
                          color: Color(0xFF3C00A7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Divider(
                      color: Color(0xFF3C00A7),
                    ),
                    ListTile(
                      title: Text(
                        'QuizMyBrain',
                        style: TextStyle(
                          color: Color(0xFF3C00A7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => QuizScreen(),
                          ),
                        );
                      },
                    ),
                    Divider(
                      color: Color(0xFF3C00A7),
                    ),
                    ListTile(
                      title: Text(
                        'GeniusPlay',
                        style: TextStyle(
                          color: Color(0xFF3C00A7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context, MaterialPageRoute(
                            builder: (context) => GeniusScreen(),
                          ),
                        );
                      },
                    ),
                    Divider(
                      color: Color(0xFF3C00A7),
                    ),
                    ListTile(
                      title: Text(
                        'MemoCheck',
                        style: TextStyle(
                          color: Color(0xFF3C00A7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {},
                    ),
                    Divider(
                      color: Color(0xFF3C00A7),
                    ),
                    ListTile(
                      title: Text(
                        'Sair',
                        style: TextStyle(
                          color: Color(0xFF3C00A7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        SystemNavigator.pop();
                      },
                    ),
                    Divider(
                      color: Color(0xFF3C00A7),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo ao Aprender+',
              style: TextStyle(
                color: Color(0xFF101010),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}