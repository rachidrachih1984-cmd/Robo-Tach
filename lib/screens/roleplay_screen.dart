import 'package:flutter/material.dart';
import 'conversation_screen.dart';

class RolePlayScreen extends StatelessWidget {
  const RolePlayScreen({super.key});

  static const scenarios = <({String title, String subtitle, IconData icon})>[
    (title: 'Restaurant', subtitle: 'Order food and speak with a waiter', icon: Icons.restaurant_outlined),
    (title: 'Hotel', subtitle: 'Check in and ask about your room', icon: Icons.hotel_outlined),
    (title: 'Airport', subtitle: 'Check in, security and boarding', icon: Icons.flight_outlined),
    (title: 'Shopping', subtitle: 'Ask prices, sizes and pay', icon: Icons.shopping_bag_outlined),
    (title: 'Work', subtitle: 'Simple conversations with colleagues', icon: Icons.work_outline),
    (title: 'Travel', subtitle: 'Ask for directions and information', icon: Icons.map_outlined),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Role-Play')),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: scenarios.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final s = scenarios[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(s.icon)),
                title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(s.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConversationScreen(teacherMode: true, scenario: s.title),
                  ),
                ),
              ),
            );
          },
        ),
      );
}