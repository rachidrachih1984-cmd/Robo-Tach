import 'package:flutter/material.dart';
import 'conversation_screen.dart';
import 'practice_screen.dart';
import 'progress_screen.dart';
import 'roleplay_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('ROBO-TACH'),
          actions: [IconButton(tooltip: 'My Progress', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())), icon: const Icon(Icons.emoji_events_outlined))],
        ),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          const SizedBox(height: 45),
          const Icon(Icons.smart_toy, size: 100),
          const Text('Hey Rachid!', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const Text('Your English buddy is ready.', textAlign: TextAlign.center),
          const SizedBox(height: 30),
          _button(Icons.forum_outlined, 'Friend Mode', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationScreen(teacherMode: false)))),
          const SizedBox(height: 12),
          _button(Icons.school_outlined, 'Teacher Mode', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConversationScreen(teacherMode: true)))),
          const SizedBox(height: 12),
          _button(Icons.theater_comedy_outlined, 'Role-Play', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RolePlayScreen()))),
          const SizedBox(height: 12),
          _button(Icons.record_voice_over_outlined, 'Pronunciation', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PracticeScreen()))),
          const SizedBox(height: 12),
          SizedBox(width: 230, child: OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())), icon: const Icon(Icons.insights_outlined), label: const Text('My Progress'))),
          const SizedBox(height: 30),
        ]),
      );

  Widget _button(IconData icon, String label, VoidCallback action) => SizedBox(width: 230, child: FilledButton.icon(onPressed: action, icon: Icon(icon), label: Text(label)));
}