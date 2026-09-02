import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText speech = SpeechToText();
  final FlutterTts tts = FlutterTts();

  Future<bool> initialize() async {
    final ready = await speech.initialize();
    await tts.setLanguage('en-US');
    await tts.setSpeechRate(0.42);
    return ready;
  }

  Future<void> startListening(void Function(String) onText) async {
    if (!speech.isAvailable) {
      await speech.initialize();
    }
    await speech.listen(
      onResult: (result) => onText(result.recognizedWords),
      listenOptions: SpeechListenOptions(
        localeId: 'en_US',
        listenMode: ListenMode.confirmation,
        partialResults: true,
      ),
    );
  }

  Future<void> stopListening() => speech.stop();

  Future<void> speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }
}
