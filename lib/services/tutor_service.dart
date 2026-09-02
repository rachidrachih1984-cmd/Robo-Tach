class TutorService {
  String reply({required String input, required bool teacherMode, String? scenario}) {
    final text = input.trim();
    if (text.isEmpty) {
      return teacherMode
          ? 'Say one short sentence in English and I will help you improve it. What would you like to say?'
          : 'I am listening, Rachid. What would you like to talk about?';
    }

    final lower = text.toLowerCase();
    if (teacherMode) {
      if (lower.contains('i am go ')) {
        return 'Good try! Say “I am going” instead of “I am go.” Can you say the full sentence again?';
      }
      if (lower.contains('i no understand') || lower.contains("i don't understood")) {
        return 'Good try! A natural sentence is “I don’t understand.” Bddarija: يعني ما فهمتش. Can you repeat: I don’t understand?';
      }
    }

    switch (scenario) {
      case 'Restaurant':
        if (lower.contains('menu')) return 'Of course. Here is the menu. Would you like something to drink first?';
        if (lower.contains('water')) return 'Certainly. I will bring you some water. What would you like to eat?';
        return 'Certainly. In a restaurant you can say “I would like …”. What would you like to order?';
      case 'Hotel':
        if (lower.contains('reservation')) return 'Great. May I have your name, please?';
        if (lower.contains('room')) return 'Your room is ready. Would you like to ask about breakfast or Wi-Fi?';
        return 'At a hotel, try “I have a reservation.” What would you like to ask the receptionist?';
      case 'Airport':
        if (lower.contains('passport')) return 'Thank you. Your passport is fine. Do you have any bags to check in?';
        if (lower.contains('gate')) return 'Your gate is shown on the boarding pass. Would you like to ask where the gate is?';
        return 'At the airport, keep your sentence short and clear. What do you need help with?';
      case 'Shopping':
        if (lower.contains('price') || lower.contains('much')) return 'It costs twenty dollars. Would you like to ask for another size?';
        if (lower.contains('size')) return 'Yes, we have another size. Would you like to try it on?';
        return 'In a shop you can ask “How much is this?” What would you like to buy?';
      case 'Work':
        return 'Good. At work, simple English is perfect. What would you like to tell your colleague?';
      case 'Travel':
        if (lower.contains('where') || lower.contains('direction')) return 'You can ask “Excuse me, how can I get there?” Where are you trying to go?';
        return 'When travelling, polite short questions work well. What information do you need?';
    }

    if (teacherMode) {
      return 'Nice sentence. I understood you. Can you tell me one more detail?';
    }
    return 'Nice to hear from you, Rachid. Tell me more about that. How did it make you feel?';
  }
}