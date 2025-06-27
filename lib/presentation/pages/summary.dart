import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:money_tracker_new/core/theme/text_styles.dart';
import 'package:money_tracker_new/presentation/widget/summary_chart.dart';
import 'package:money_tracker_new/provider/transaction_provider.dart';
import '../../layout/master_layout.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  String _formatCurrency(double value) {
    return NumberFormat.currency(locale: 'id', symbol: 'IDR ', decimalDigits: 2)
        .format(value);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    // Jalankan hanya sekali saat build pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.loadDashboardSummary();
    });

    return MasterLayout(
      child: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, provider, _) {
            final totalValue = _formatCurrency(provider.totalValue);
            final totalIncome = _formatCurrency(provider.totalIncome);
            final totalExpense = _formatCurrency(provider.totalExpense);

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: AppTextStyles.headline1
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      // Card summary hijau
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.green.shade900.withOpacity(0.4),
                              offset: const Offset(0, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _summaryItem('Total Value saat ini', totalValue),
                            const Divider(color: Colors.white54),
                            _summaryItem('Total Income', totalIncome,
                                showAllTime: true),
                            const Divider(color: Colors.white54),
                            _summaryItem('Total Pengeluaran', totalExpense,
                                showAllTime: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Title chart
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Income VS Pengeluaran',
                    style:
                        AppTextStyles.headline1.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                // Chart widget
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SummaryChart(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String amount, {bool showAllTime = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showAllTime)
              const Text(
                'All Time',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
      ],
    );
  }
}
