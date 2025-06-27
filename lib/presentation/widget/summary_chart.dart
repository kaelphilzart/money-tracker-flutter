import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_tracker_new/provider/transaction_provider.dart';
import 'package:provider/provider.dart';

class SummaryChart extends StatefulWidget {
  const SummaryChart({super.key});

  @override
  State<SummaryChart> createState() => _SummaryChartState();
}

class _SummaryChartState extends State<SummaryChart> {
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false)
          .loadChartSummaryByYear(selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final incomeData = provider.chartDataIncome;
    final expenseData = provider.chartDataExpense;
    final isLoading = provider.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Pilih Tahun:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: selectedYear,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedYear = value);
                  provider.loadChartSummaryByYear(value);
                }
              },
              items: List.generate(5, (i) {
                int year = DateTime.now().year - i;
                return DropdownMenuItem(
                    value: year, child: Text(year.toString()));
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Legend (Indikator)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              _Legend(color: Colors.green, label: 'Income'),
              SizedBox(width: 16),
              _Legend(color: Colors.red, label: 'Pengeluaran'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Chart or Loading
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: _getMaxY(incomeData, expenseData),
                    titlesData: const FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: _bottomTitles,
                          reservedSize: 32,
                        ),
                      ),
                      topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                  ),
                    barGroups: List.generate(12, (index) {
                      final incomeY =
                          index < incomeData.length ? incomeData[index].y : 0.0;
                      final expenseY =
                          index < expenseData.length ? expenseData[index].y : 0.0;
                      return BarChartGroupData(
                        x: index + 1,
                        barsSpace: 4,
                        barRods: [
                          BarChartRodData(
                            toY: incomeY,
                            color: Colors.green,
                            width: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          BarChartRodData(
                            toY: expenseY,
                            color: Colors.red,
                            width: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.black87,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          String label = rod.color == Colors.green
                              ? 'Income'
                              : 'Pengeluaran';
                          return BarTooltipItem(
                            '$label\n${rod.toY.toStringAsFixed(0)}',
                            const TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  static double _getMaxY(List<FlSpot> income, List<FlSpot> expense) {
    final allValues = [...income, ...expense].map((e) => e.y).toList();
    if (allValues.isEmpty) return 100; // default maxY kalau nggak ada data
    double max = allValues.reduce((a, b) => a > b ? a : b);
    return (max * 1.2).ceilToDouble();
  }

  static Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    String text = '';
    if (value.toInt() >= 1 && value.toInt() <= 12) {
      text = monthNames[value.toInt() - 1];
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
