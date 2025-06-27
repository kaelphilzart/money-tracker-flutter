import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker_new/provider/transaction_provider.dart';
import 'package:money_tracker_new/provider/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedRange = "1M";
  bool _isVisible = true;

  final currencyFormat =
      NumberFormat.currency(locale: 'id', symbol: 'IDR ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TransactionProvider>();
      provider.loadTotalValue();
      provider.loadTransactionsByRange(selectedRange);

      final userProvider = context.read<UserProvider>();
      userProvider.fetchUser();
    });
  }

  void _onRangeSelected(String range) {
    setState(() {
      selectedRange = range;
    });
    context.read<TransactionProvider>().loadTransactionsByRange(range);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                final nameFromDb = userProvider.user?.name.trim();
                final name = (nameFromDb == null || nameFromDb.isEmpty)
                    ? 'Pengguna'
                    : nameFromDb;
                return Text(
                  "Hallo, $name",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Total Value
            _buildTotalValueCard(),

            const SizedBox(height: 32),
            const Text(
              "Statistical Value",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Chart
            _buildChartSection(),

            const SizedBox(height: 16),

            // Filter
            _buildRangeFilter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalValueCard() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF1E1E1E),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Total Value",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  provider.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          _isVisible
                              ? currencyFormat.format(provider.totalValue)
                              : '•••••••',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  IconButton(
                    icon: Icon(
                      _isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/summary');
                },
                icon: const Icon(Icons.list),
                label: const Text(
                  "Summary",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChartSection() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, _) {
        final isLoading = provider.isLoading;
        final spots = provider.chartData.isNotEmpty
            ? provider.chartData
            : [const FlSpot(0, 0)];

        final maxSpot = spots.reduce((a, b) => a.y > b.y ? a : b);

        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Colors.greenAccent,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            // ignore: deprecated_member_use
                            color: Colors.greenAccent.withOpacity(0.2),
                          ),
                        ),
                      ],
                      extraLinesData: ExtraLinesData(
                        extraLinesOnTop: true,
                        horizontalLines: [
                          HorizontalLine(
                            y: maxSpot.y,
                            label: HorizontalLineLabel(
                              show: true,
                              alignment: Alignment.topCenter,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              labelResolver: (_) =>
                                  currencyFormat.format(maxSpot.y),
                            ),
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildRangeFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ["1D", "1W", "1M", "1Y"].map((range) {
          final isSelected = selectedRange == range;
          return GestureDetector(
            onTap: () => _onRangeSelected(range),
            child: Container(
              width: 60,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green),
              ),
              child: Text(
                range,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
