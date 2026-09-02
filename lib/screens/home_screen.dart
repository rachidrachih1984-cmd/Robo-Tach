import 'package:flutter/material.dart';
import 'conversation_screen.dart';
import 'progress_screen.dart';
import 'roleplay_screen.dart';

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
            _button(context, Icons.forum_outlined, 'Friend Mode', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationScreen(teacherMode: false)))),
            const SizedBox(height: 12),
            _button(context, Icons.school_outlined, 'Teacher Mode', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationScreen(teacherMode: true)))),
            const SizedBox(height: 12),
            _button(context, Icons.theater_comedy_outlined, 'Role-Play', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RolePlayScreen()))),
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

  Widget _button(BuildContext context, IconData icon, String label, VoidCallback action) => SizedBox(
        width: 230,
        child: FilledButton.icon(onPressed: action, icon: Icon(icon), label: Text(label)),
      );
}