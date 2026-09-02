import 'dart:convert';
import 'package:http/http.dart' as http;
import 'tutor_service.dart';

class TutorMessage {
  final String role;
  final String text;
  const TutorMessage(this.role, this.text);

  Map<String, dynamic> toJson() => {'role': role, 'text': text};
}

class AiTutorService {
  static const String endpoint = String.fromEnvironment('ROBO_TACH_AI_URL');
  final TutorService fallback;
  final http.Client client;

  AiTutorService({TutorService? fallback, http.Client? client})
      : fallback = fallback ?? TutorService(),
        client = client ?? http.Client();

  bool get remoteEnabled => endpoint.trim().isNotEmpty;

  Future<String> reply({
    required String input,
    required bool teacherMode,
    String? scenario,
    required List<TutorMessage> history,
  }) async {
    if (!remoteEnabled) {
      return fallback.reply(input: input, teacherMode: teacherMode, scenario: scenario);
    }

    try {
      final response = await client
          .post(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'learner': {'name': 'Rachid', 'level': 'A1 Beginner', 'nativeLanguage': 'Moroccan Darija'},
              'mode': teacherMode ? 'teacher' : 'friend',
              'scenario': scenario,
              'message': input,
              'history': history.map((m) => m.toJson()).toList(),
              'rules': {
                'shortNaturalReplies': true,
                'gentleCorrections': true,
                'darijaWhenHelpful': true,
                'oneQuestionAtEnd': true,
              }
            }),
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('AI service returned ${response.statusCode}');
      }
      final data = jsonDecode(response.body);
      final text = data is Map<String, dynamic> ? data['reply']?.toString().trim() : null;
      if (text == null || text.isEmpty) throw Exception('AI reply missing');
      return text;
    } catch (_) {
      return fallback.reply(input: input, teacherMode: teacherMode, scenario: scenario);
    }
  }

  void dispose() => client.close();
}