import 'package:shared_preferences/shared_preferences.dart';

class LearnerProgress {
  final String name;
  final String level;
  final int xp;
  final int sessions;
  final int streak;
  final String lastTopic;

  const LearnerProgress({
    required this.name,
    required this.level,
    required this.xp,
    required this.sessions,
    required this.streak,
    required this.lastTopic,
  });
}

class MemoryService {
  static const _nameKey = 'learner_name';
  static const _levelKey = 'learner_level';
  static const _xpKey = 'xp';
  static const _sessionsKey = 'sessions';
  static const _streakKey = 'streak';
  static const _lastTopicKey = 'last_topic';

  Future<LearnerProgress> load() async {
    final prefs = await SharedPreferences.getInstance();
    return LearnerProgress(
      name: prefs.getString(_nameKey) ?? 'Rachid',
      level: prefs.getString(_levelKey) ?? 'A1 Beginner',
      xp: prefs.getInt(_xpKey) ?? 0,
      sessions: prefs.getInt(_sessionsKey) ?? 0,
      streak: prefs.getInt(_streakKey) ?? 0,
      lastTopic: prefs.getString(_lastTopicKey) ?? 'Getting started',
    );
  }

  Future<LearnerProgress> recordPractice({required String topic, int xpEarned = 5}) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    await prefs.setInt(_xpKey, current.xp + xpEarned);
    await prefs.setInt(_sessionsKey, current.sessions + 1);
    await prefs.setInt(_streakKey, current.streak == 0 ? 1 : current.streak);
    await prefs.setString(_lastTopicKey, topic);
    return load();
  }

  Future<void> saveLevel(String level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_levelKey, level);
  }
}