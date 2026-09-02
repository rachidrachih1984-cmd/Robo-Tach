import 'package:flutter/material.dart';
import '../services/memory_service.dart';
import '../services/tutor_service.dart';
import '../services/voice_service.dart';

class ConversationScreen extends StatefulWidget {
  final bool teacherMode;
  const ConversationScreen({super.key, required this.teacherMode});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final VoiceService _voice = VoiceService();
  final TutorService _tutor = TutorService();
  final MemoryService _memory = MemoryService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final List<_ChatLine> _messages = [];
  bool _ready = false;
  bool _listening = false;
  String? _voiceError;

  @override
  void initState() {
    super.initState();
    _messages.add(_ChatLine(
      fromRobot: true,
      text: widget.teacherMode
          ? 'Hey Rachid! Say one short sentence in English and I will help you improve it.'
          : 'Hey Rachid! Tell me something about your day.',
    ));
    _initVoice();
  }

  Future<void> _initVoice() async {
    try {
      final ready = await _voice.initialize();
      if (!mounted) return;
      setState(() {
        _ready = ready;
        _voiceError = ready ? null : 'Microphone speech recognition is unavailable. You can still type.';
      });
      if (ready) await _voice.speak(_messages.first.text);
    } catch (_) {
      if (!mounted) return;
      setState(() => _voiceError = 'Voice could not start. You can still type and send messages.');
    }
  }

  Future<void> _toggleMic() async {
    if (!_ready) return;
    try {
      if (_listening) {
        await _voice.stopListening();
        if (mounted) setState(() => _listening = false);
        return;
      }
      setState(() {
        _listening = true;
        _voiceError = null;
      });
      await _voice.startListening((text) {
        if (!mounted) return;
        setState(() {
          _controller.text = text;
          _controller.selection = TextSelection.collapsed(offset: text.length);
        });
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _listening = false;
        _voiceError = 'I could not use the microphone. Check microphone permission or type your sentence.';
      });
    }
  }

  Future<void> _send() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;
    try {
      await _voice.stopListening();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _listening = false;
      _messages.add(_ChatLine(fromRobot: false, text: input));
      _controller.clear();
    });

    final reply = _tutor.reply(input: input, teacherMode: widget.teacherMode);
    setState(() => _messages.add(_ChatLine(fromRobot: true, text: reply)));
    _scrollToBottom();
    await _memory.recordPractice(topic: widget.teacherMode ? 'Teacher Mode' : 'Friend Mode');
    try {
      await _voice.speak(reply);
    } catch (_) {
      if (mounted) setState(() => _voiceError = 'Text reply works, but I could not play the voice.');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _voice.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.teacherMode ? 'Teacher Mode' : 'Friend Mode')),
        body: SafeArea(
          child: Column(children: [
            const SizedBox(height: 12),
            const Icon(Icons.smart_toy_rounded, size: 78),
            Text(_listening ? 'Listening...' : (_ready ? 'Robo-Tach is ready' : 'Voice unavailable — typing works')),
            if (_voiceError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(_voiceError!, textAlign: TextAlign.center),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.fromRobot ? Alignment.centerLeft : Alignment.centerRight,
                    child: Card(child: Padding(padding: const EdgeInsets.all(12), child: Text(message.text))),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
              child: Row(children: [
                IconButton.filled(
                  onPressed: _ready ? _toggleMic : null,
                  icon: Icon(_listening ? Icons.stop : Icons.mic),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    decoration: const InputDecoration(hintText: 'Speak or type in English...', border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: _send, icon: const Icon(Icons.send)),
              ]),
            ),
          ]),
        ),
      );
}

class _ChatLine {
  final bool fromRobot;
  final String text;
  const _ChatLine({required this.fromRobot, required this.text});
}