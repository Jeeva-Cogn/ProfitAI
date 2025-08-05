import 'package:flutter/material.dart';

import 'glass_card.dart';

class BudgetProgress extends StatelessWidget {
  final String title;
  final double spent;
  final double budget;
  final IconData icon;
  final Color color;

  const BudgetProgress({
    super.key,
    required this.title,
    required this.spent,
    required this.budget,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(icon, color: color, size: 28),
                      SizedBox(width: 8),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color), overflow: TextOverflow.ellipsis),
                      ),
                      Spacer(),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text('\u20b9$spent / \u20b9$budget', style: TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis, textAlign: TextAlign.right),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    '₹${spent.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: percentage > 0.8 ? Colors.red : color,
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    'of ₹${budget.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: color.withValues(alpha: 0.1),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                      colors: percentage > 0.8 
                          ? [Colors.orange, Colors.red]
                          : [color.withValues(alpha: 0.7), color],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(percentage * 100).toStringAsFixed(0)}% used',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: percentage > 0.8 ? Colors.red : color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
