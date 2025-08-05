class Transaction {
  final String merchant;
  final double amount;
  final String date;
  final String category;

  Transaction({
    required this.merchant,
    required this.amount,
    required this.date,
    required this.category,
  });
}
