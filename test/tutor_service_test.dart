import 'package:flutter_test/flutter_test.dart';
import 'package:robo_tach/services/tutor_service.dart';

void main() {
  final tutor = TutorService();

  test('teacher mode corrects a common continuous tense mistake', () {
    final reply = tutor.reply(input: 'I am go to work', teacherMode: true);
    expect(reply, contains('I am going'));
    expect(reply.trim().endsWith('?'), isTrue);
  });

  test('teacher mode can explain a common phrase with Darija help', () {
    final reply = tutor.reply(input: 'I no understand', teacherMode: true);
    expect(reply, contains('I don’t understand'));
    expect(reply, contains('ما فهمتش'));
    expect(reply.trim().endsWith('?'), isTrue);
  });

  test('friend mode stays conversational and asks one question', () {
    final reply = tutor.reply(input: 'Today was good', teacherMode: false);
    expect(reply, contains('Rachid'));
    expect('?'.allMatches(reply).length, 1);
  });
}