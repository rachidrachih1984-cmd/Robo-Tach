import 'package:flutter/material.dart';
import '../services/memory_service.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final MemoryService _memory = MemoryService();
  LearnerProgress? _progress;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await _memory.load();
    if (mounted) setState(() => _progress = value);
  }

  @override
  Widget build(BuildContext context) {
    final p = _progress;
    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: p == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Icon(Icons.emoji_events_rounded, size: 76),
                const SizedBox(height: 12),
                Text('${p.name} • ${p.level}', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 24),
                _tile(Icons.bolt, '${p.xp} XP', 'Practice points'),
                _tile(Icons.chat_bubble_outline, '${p.sessions}', 'Practice turns'),
                _tile(Icons.local_fire_department_outlined, '${p.streak} day', 'Current streak'),
                _tile(Icons.history, p.lastTopic, 'Last practice'),
              ],
            ),
    );
  }

  Widget _tile(IconData icon, String value, String label) => Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(label),
        ),
      );
}