// lib/features/summary/data/dummy_summary_chart_data.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SummaryChartData {
  static List<BarChartGroupData> get barGroups {
    return List.generate(8, (index) {
      final income = (index + 1) * 10.0;
      final expense = (index % 3 + 1) * 5.0;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: income,
            color: Colors.green,
            width: 10,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
          BarChartRodData(
            toY: -expense,
            color: Colors.red,
            width: 10,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }
}
