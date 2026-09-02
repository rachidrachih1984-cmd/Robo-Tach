import 'package:flutter/material.dart';
import 'conversation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('ROBO-TACH')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const Spacer(),
        const Icon(Icons.smart_toy, size: 100),
        const Text('Hey Rachid!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const Text('Your English buddy is ready.'),
        const SizedBox(height: 30),
        FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationScreen(teacherMode: false))), child: const Text('Friend Mode')),
        const SizedBox(height: 12),
        FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationScreen(teacherMode: true))), child: const Text('Teacher Mode')),
        const Spacer(),
      ]),
    ),
  );
}
