import 'package:calcly/pages/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: Column(
                children: [
                  Text('Calcly'
                  ,style: TextStyle(
                    fontSize: 42.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),),
                  Text('Choose your calculus level'
                    ,style: TextStyle(
                        fontSize: 12,
                        color: Colors.black
                    ),),
                ],
              ),
            ),
            SizedBox(height: 20),
            Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text("Reccomended Calculus Videos"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  RoundedButton(title: 'Calculus 1'),
                  SizedBox(height: 20),
                  RoundedButton(title: 'Calculus 2'),
                  SizedBox(height: 20),
                  RoundedButton(title: 'Calculus 3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String title;

  const RoundedButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }
}