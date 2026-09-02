import 'package:flutter/material.dart';
import '../services/voice_service.dart';

class ConversationScreen extends StatefulWidget {
  final bool teacherMode;
  const ConversationScreen({super.key, required this.teacherMode});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final VoiceService _voice = VoiceService();
  final TextEditingController _controller = TextEditingController();
  final List<_ChatLine> _messages = [];
  bool _ready = false;
  bool _listening = false;

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
    final ready = await _voice.initialize();
    if (!mounted) return;
    setState(() => _ready = ready);
    if (ready) {
      await _voice.speak(_messages.first.text);
    }
  }

  Future<void> _toggleMic() async {
    if (!_ready) return;
    if (_listening) {
      await _voice.stopListening();
      if (mounted) setState(() => _listening = false);
      return;
    }

    setState(() => _listening = true);
    await _voice.startListening((text) {
      if (!mounted) return;
      setState(() => _controller.text = text);
    });
  }

  Future<void> _send() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    await _voice.stopListening();
    setState(() {
      _listening = false;
      _messages.add(_ChatLine(fromRobot: false, text: input));
      _controller.clear();
    });

    final reply = _makeDemoReply(input);
    setState(() => _messages.add(_ChatLine(fromRobot: true, text: reply)));
    await _voice.speak(reply);
  }

  String _makeDemoReply(String input) {
    final lower = input.toLowerCase();
    if (widget.teacherMode) {
      if (lower.contains('i go') && lower.contains('yesterday')) {
        return 'Good try! Say: I went yesterday. "Went" is the past form of "go". Can you repeat it?';
      }
      return 'Nice sentence. I understood you. Try saying it once more, slowly and clearly.';
    }
    if (lower.contains('good') || lower.contains('fine')) {
      return 'That is great! What made your day good?';
    }
    return 'I am listening, my friend. Tell me a little more.';
  }

  @override
  void dispose() {
    _controller.dispose();
    _voice.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.teacherMode ? 'Teacher Mode' : 'Friend Mode')),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Icon(Icons.smart_toy_rounded, size: 78),
              Text(
                _listening ? 'Listening...' : (_ready ? 'Robo-Tach is ready' : 'Preparing microphone...'),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return Align(
                      alignment: message.fromRobot ? Alignment.centerLeft : Alignment.centerRight,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(message.text),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
                child: Row(
                  children: [
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
                        decoration: const InputDecoration(
                          hintText: 'Speak or type in English...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: _send,
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _ChatLine {
  final bool fromRobot;
  final String text;
  const _ChatLine({required this.fromRobot, required this.text});
}
