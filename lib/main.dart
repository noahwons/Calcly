import 'package:calcly/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  double _logoOpacity = 0.0;
  double _textOpacity = 0.0;
  String _displayedText = "";
  final String _fullText = "Welcome to Calcly";
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();
    _fadeInLogo();
  }

  void _fadeInLogo() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _logoOpacity = 1.0;
      });
      _fadeInText();
    });
  }

  void _fadeInText() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _textOpacity = 1.0;
      });
      _startTyping();
    });
  }

  void _startTyping() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_textIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_textIndex];
          _textIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 75),
                    AnimatedOpacity(
                      opacity: _logoOpacity,
                      duration: const Duration(seconds: 2),
                      child: Image.asset(
                        'assets/images/calcly_logo.png',
                        height: 200,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedOpacity(
                      opacity: _textOpacity,
                      duration: const Duration(seconds: 2),
                      child: Text(
                        _displayedText,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Column(
                  children: [
                    const RoundedButton(title: 'Get Started', color: Colors.black),
                    // SizedBox(height: 20),
                    // RoundedButton(title: 'Create Account', color: Colors.black),
                    // SizedBox(height: 20),
                    // const RoundedButton(title: 'Login', color: Colors.black),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String title;
  final Color? color;

  const RoundedButton({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        child: Text(
          title,
          style: TextStyle(
            color: color == Colors.black ? Colors.white : Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}