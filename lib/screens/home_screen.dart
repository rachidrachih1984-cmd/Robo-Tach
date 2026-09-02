import 'package:flutter/material.dart';
import 'conversation_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ROBO-TACH'),
          actions: [
            IconButton(
              tooltip: 'My Progress',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())),
              icon: const Icon(Icons.emoji_events_outlined),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Spacer(),
            const Icon(Icons.smart_toy, size: 100),
            const Text('Hey Rachid!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text('Your English buddy is ready.'),
            const SizedBox(height: 30),
            SizedBox(
              width: 230,
              child: FilledButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationScreen(teacherMode: false))),
                icon: const Icon(Icons.forum_outlined),
                label: const Text('Friend Mode'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 230,
              child: FilledButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationScreen(teacherMode: true))),
                icon: const Icon(Icons.school_outlined),
                label: const Text('Teacher Mode'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 230,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())),
                icon: const Icon(Icons.insights_outlined),
                label: const Text('My Progress'),
              ),
            ),
            const Spacer(),
          ]),
        ),
      );
}