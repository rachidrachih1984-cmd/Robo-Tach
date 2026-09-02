import 'package:flutter/material.dart';
import '../services/ai_tutor_service.dart';
import '../services/memory_service.dart';
import '../services/voice_service.dart';

class ConversationScreen extends StatefulWidget {
  final bool teacherMode;
  final String? scenario;
  const ConversationScreen({super.key, required this.teacherMode, this.scenario});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final VoiceService _voice = VoiceService();
  final AiTutorService _tutor = AiTutorService();
  final MemoryService _memory = MemoryService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_ChatLine> _messages = [];
  bool _ready = false;
  bool _listening = false;
  bool _thinking = false;
  String? _voiceError;

  String get _title => widget.scenario == null ? (widget.teacherMode ? 'Teacher Mode' : 'Friend Mode') : '${widget.scenario} Role-Play';

  String get _opening {
    switch (widget.scenario) {
      case 'Restaurant': return 'Welcome! I am your waiter. Good evening, Rachid. What would you like to order?';
      case 'Hotel': return 'Welcome to the hotel, Rachid. Do you have a reservation?';
      case 'Airport': return 'Good morning, Rachid. May I see your passport and ticket, please?';
      case 'Shopping': return 'Hello, Rachid. Can I help you find something today?';
      case 'Work': return 'Good morning, Rachid. How is your work going today?';
      case 'Travel': return 'Hello, Rachid. Where would you like to go?';
      default: return widget.teacherMode ? 'Hey Rachid! Say one short sentence in English and I will help you improve it.' : 'Hey Rachid! Tell me something about your day.';
    }
  }

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatLine(fromRobot: true, text: _opening));
    _initVoice();
  }

  Future<void> _initVoice() async {
    try {
      final ready = await _voice.initialize();
      if (!mounted) return;
      setState(() { _ready = ready; _voiceError = ready ? null : 'Microphone speech recognition is unavailable. You can still type.'; });
      if (ready) await _voice.speak(_messages.first.text);
    } catch (_) {
      if (mounted) setState(() => _voiceError = 'Voice could not start. You can still type and send messages.');
    }
  }

  Future<void> _toggleMic() async {
    if (!_ready || _thinking) return;
    try {
      if (_listening) {
        await _voice.stopListening();
        if (mounted) setState(() => _listening = false);
        return;
      }
      setState(() { _listening = true; _voiceError = null; });
      await _voice.startListening((text) {
        if (!mounted) return;
        setState(() { _controller.text = text; _controller.selection = TextSelection.collapsed(offset: text.length); });
      });
    } catch (_) {
      if (mounted) setState(() { _listening = false; _voiceError = 'I could not use the microphone. Check microphone permission or type your sentence.'; });
    }
  }

  Future<void> _send() async {
    final input = _controller.text.trim();
    if (input.isEmpty || _thinking) return;
    try { await _voice.stopListening(); } catch (_) {}
    if (!mounted) return;
    final history = _messages.map((m) => TutorMessage(m.fromRobot ? 'assistant' : 'user', m.text)).toList();
    setState(() { _listening = false; _thinking = true; _messages.add(_ChatLine(fromRobot: false, text: input)); _controller.clear(); });

    final reply = await _tutor.reply(input: input, teacherMode: widget.teacherMode, scenario: widget.scenario, history: history);
    if (!mounted) return;
    setState(() { _thinking = false; _messages.add(_ChatLine(fromRobot: true, text: reply)); });
    _scrollToBottom();
    await _memory.recordPractice(topic: widget.scenario ?? (widget.teacherMode ? 'Teacher Mode' : 'Friend Mode'));
    try { await _voice.speak(reply); } catch (_) {
      if (mounted) setState(() => _voiceError = 'Text reply works, but I could not play the voice.');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _voice.stopListening();
    _tutor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: SafeArea(child: Column(children: [
          const SizedBox(height: 12),
          const Icon(Icons.smart_toy_rounded, size: 78),
          Text(_thinking ? 'Robo-Tach is thinking...' : (_listening ? 'Listening...' : (_ready ? 'Robo-Tach is ready' : 'Voice unavailable — typing works'))),
          if (_voiceError != null) Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: Text(_voiceError!, textAlign: TextAlign.center)),
          const SizedBox(height: 8),
          Expanded(child: ListView.builder(controller: _scroll, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _messages.length, itemBuilder: (context, index) {
            final message = _messages[index];
            return Align(alignment: message.fromRobot ? Alignment.centerLeft : Alignment.centerRight, child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(message.text))));
          })),
          Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 14), child: Row(children: [
            IconButton.filled(onPressed: _ready && !_thinking ? _toggleMic : null, icon: Icon(_listening ? Icons.stop : Icons.mic)),
            const SizedBox(width: 8),
            Expanded(child: TextField(enabled: !_thinking, controller: _controller, textInputAction: TextInputAction.send, onSubmitted: (_) => _send(), decoration: const InputDecoration(hintText: 'Speak or type in English...', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            IconButton.filled(onPressed: _thinking ? null : _send, icon: _thinking ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send)),
          ])),
        ])),
      );
}

class _ChatLine {
  final bool fromRobot;
  final String text;
  const _ChatLine({required this.fromRobot, required this.text});
}