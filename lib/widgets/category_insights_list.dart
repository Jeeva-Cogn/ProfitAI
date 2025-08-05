import 'package:flutter/material.dart';

class CategoryInsightsList extends StatelessWidget {
  final Map<String, double> insights;
  const CategoryInsightsList({super.key, required this.insights});

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'bills':
        return Icons.receipt_long;
      case 'personal':
        return Icons.person;
      case 'transport':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'shopping':
        return Colors.blue;
      case 'bills':
        return Colors.red;
      case 'personal':
        return Colors.green;
      case 'transport':
        return Colors.purple;
      case 'entertainment':
        return Colors.pink;
      default:
        return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = insights.keys.toList();
    final total = insights.values.fold(0.0, (a, b) => a + b);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Category Insights',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final category = categories[i];
          final amount = insights[category] ?? 0;
          final percentage = total > 0 ? (amount / total * 100).toStringAsFixed(1) : '0';
          
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  color: _getCategoryColor(category),
                  size: 24,
                ),
              ),
              title: Text(
                category,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                '$percentage% of total spending',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${amount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 4,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: total > 0 ? (amount / total).clamp(0.0, 1.0) : 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
