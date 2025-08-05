import 'package:flutter/material.dart';

class WalletFlowLogo extends StatelessWidget {
  final double size;
  const WalletFlowLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.account_balance_wallet,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }
}
