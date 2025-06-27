import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_tracker_new/provider/transaction_provider.dart';
import 'package:intl/intl.dart';

class DashboardSummary extends StatelessWidget {
  const DashboardSummary({super.key});

  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'id', symbol: 'IDR ', decimalDigits: 2)
        .format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final totalValue = provider.totalValue;
        final totalIncome = provider.totalIncome;
        final totalExpense = provider.totalExpense;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SummaryRow(
                  title: 'Total Value saat ini',
                  value: _formatCurrency(totalValue),
                ),
                const Divider(color: Colors.white54),
                _SummaryRow(
                  title: 'Total Income',
                  value: _formatCurrency(totalIncome),
                  trailing: 'All Time',
                ),
                const SizedBox(height: 8),
                _SummaryRow(
                  title: 'Total Pengeluaran',
                  value: _formatCurrency(totalExpense),
                  trailing: 'All Time',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final String? trailing;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              if (trailing != null)
                Text(trailing!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
