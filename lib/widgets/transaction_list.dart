import 'package:flutter/material.dart';
import 'glass_card.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  const TransactionList({super.key, required this.transactions});

  IconData _getCategoryIcon(String merchant) {
    final lowerMerchant = merchant.toLowerCase();
    if (lowerMerchant.contains('amazon') || lowerMerchant.contains('flipkart')) {
      return Icons.shopping_bag;
    } else if (lowerMerchant.contains('swiggy') || lowerMerchant.contains('zomato') || lowerMerchant.contains('baker')) {
      return Icons.restaurant;
    } else if (lowerMerchant.contains('uber') || lowerMerchant.contains('ola')) {
      return Icons.directions_car;
    } else {
      return Icons.account_balance_wallet;
    }
  }

  Color _getCategoryColor(String merchant) {
    final lowerMerchant = merchant.toLowerCase();
    if (lowerMerchant.contains('amazon') || lowerMerchant.contains('flipkart')) {
      return Colors.blue;
    } else if (lowerMerchant.contains('swiggy') || lowerMerchant.contains('zomato') || lowerMerchant.contains('baker')) {
      return Colors.orange;
    } else if (lowerMerchant.contains('uber') || lowerMerchant.contains('ola')) {
      return Colors.green;
    } else {
      return Colors.indigo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'Transactions',
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
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final tx = transactions[i];
          final merchant = tx['merchant'] ?? 'Unknown';
          final amount = tx['amount'] ?? 0;
          final date = tx['date'] ?? '';
          
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(merchant).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(merchant),
                  color: _getCategoryColor(merchant),
                  size: 24,
                ),
              ),
              title: Text(
                merchant,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                date,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              trailing: Text(
                '₹$amount',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
