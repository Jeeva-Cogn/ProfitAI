import 'package:flutter/material.dart';

class ProfileBadges extends StatelessWidget {
  final List<String> badges;
  const ProfileBadges({super.key, required this.badges});

  IconData _getBadgeIcon(String badge) {
    if (badge.contains('Saved')) return Icons.savings;
    if (badge.contains('Zero Spend')) return Icons.block;
    if (badge.contains('Streak')) return Icons.local_fire_department;
    if (badge.contains('Level')) return Icons.trending_up;
    return Icons.emoji_events;
  }

  Color _getBadgeColor(String badge) {
    if (badge.contains('Saved')) return Colors.green;
    if (badge.contains('Zero Spend')) return Colors.blue;
    if (badge.contains('Streak')) return Colors.orange;
    if (badge.contains('Level')) return Colors.purple;
    return Colors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Achievements',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: badges.map((badge) {
            final color = _getBadgeColor(badge);
            final icon = _getBadgeIcon(badge);
            
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: color.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    badge,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Level 5 Saver',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.75,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
              const SizedBox(height: 8),
              Text(
                '75% to Level 6',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
