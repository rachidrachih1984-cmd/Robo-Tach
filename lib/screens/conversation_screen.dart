import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
  final bool teacherMode;
  const ConversationScreen({super.key, required this.teacherMode});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(teacherMode ? 'Teacher Mode' : 'Friend Mode')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(children: [
        const Text('🤖', style: TextStyle(fontSize: 90)),
        const SizedBox(height: 20),
        Text(teacherMode ? 'Say one short sentence. I will help you improve it.' : 'Tell me something about your day.', textAlign: TextAlign.center),
        const Spacer(),
        const TextField(decoration: InputDecoration(hintText: 'Speak or type in English…')),
        const SizedBox(height: 12),
        FilledButton.icon(onPressed: null, icon: Icon(Icons.mic), label: Text('Voice practice')),
      ]),
    ),
  );
}
