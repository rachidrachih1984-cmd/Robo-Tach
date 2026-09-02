import 'package:flutter/material.dart';
import '../services/voice_service.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});
  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final VoiceService _voice = VoiceService();
  final phrases = const ['How are you today?', 'I would like a coffee, please.', 'Can you help me?', 'I have a reservation.', 'Where is the airport?'];
  int index = 0;
  String heard = '';
  bool ready = false;

  @override
  void initState() { super.initState(); _init(); }
  Future<void> _init() async { final r = await _voice.initialize(); if (mounted) setState(() => ready = r); }
  String _normalize(String value) => value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), '').replaceAll(RegExp(r'\s+'), ' ').trim();
  int get score {
    if (heard.isEmpty) return 0;
    final target = _normalize(phrases[index]).split(' ').toSet();
    final actual = _normalize(heard).split(' ').toSet();
    if (target.isEmpty) return 0;
    return ((target.intersection(actual).length / target.length) * 100).round();
  }
  Future<void> _listen() async { setState(() => heard = ''); await _voice.startListening((text) { if (mounted) setState(() => heard = text); }); }
  @override
  void dispose() { _voice.stopListening(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pronunciation Practice')),
    body: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.record_voice_over_outlined, size: 76),
      const SizedBox(height: 20),
      const Text('Listen, then repeat', style: TextStyle(fontSize: 18)),
      const SizedBox(height: 12),
      Text(phrases[index], textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      const SizedBox(height: 18),
      FilledButton.icon(onPressed: () => _voice.speak(phrases[index]), icon: const Icon(Icons.volume_up), label: const Text('Listen')),
      const SizedBox(height: 10),
      FilledButton.icon(onPressed: ready ? _listen : null, icon: const Icon(Icons.mic), label: const Text('Repeat')),
      const SizedBox(height: 20),
      if (heard.isNotEmpty) ...[
        Text('I heard: “$heard”', textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Word match: $score%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const Text('This is a practice match, not a full accent score.'),
      ],
      const SizedBox(height: 20),
      OutlinedButton(onPressed: () => setState(() { index = (index + 1) % phrases.length; heard = ''; }), child: const Text('Next phrase')),
    ])),
  );
}