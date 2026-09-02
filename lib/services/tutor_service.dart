class TutorService {
  String reply({required String input, required bool teacherMode}) {
    final text = input.trim();
    if (text.isEmpty) {
      return teacherMode
          ? 'Say one short sentence in English and I will help you improve it. What would you like to say?'
          : 'I am listening, Rachid. What would you like to talk about?';
    }

    if (teacherMode) {
      final lower = text.toLowerCase();
      if (lower.contains('i am go ')) {
        return 'Good try! Say “I am going” instead of “I am go.” Can you say the full sentence again?';
      }
      if (lower.contains('i no understand') || lower.contains("i don't understood")) {
        return 'Good try! A natural sentence is “I don’t understand.” Bddarija: يعني ما فهمتش. Can you repeat: I don’t understand?';
      }
      return 'Nice sentence. I understood you. Can you tell me one more detail?';
    }

    return 'Nice to hear from you, Rachid. Tell me more about that. How did it make you feel?';
  }
}