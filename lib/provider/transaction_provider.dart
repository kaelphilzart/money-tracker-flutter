import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_tracker_new/data/models/transaction_model.dart';
import 'package:money_tracker_new/data/repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repo = TransactionRepository();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  double _totalValue = 0.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  // Chart data for yearly summary
  List<FlSpot> _chartDataIncome = [];
  List<FlSpot> _chartDataExpense = []; 

  List<FlSpot> _chartData = [];

  List<TransactionModel> get transactions => _transactions;
  List<FlSpot> get chartData => _chartData;
  bool get isLoading => _isLoading;
  double get totalValue => _totalValue;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;

  // =============================
  // Filter state
  int _sentiment = 0;
  String? _selectedCategory;
  DateTime? _startDate;
  DateTime? _endDate;

  int get sentiment => _sentiment;
  String? get selectedCategory => _selectedCategory;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setSentiment(int value) {
    _sentiment = value;
    notifyListeners();
  }

  void setCategory(String? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  void setStartDate(DateTime? value) {
    _startDate = value;
    notifyListeners();
  }

  void setEndDate(DateTime? value) {
    _endDate = value;
    notifyListeners();
  }

  // =============================
  // Core functions

  Future<void> loadTotalValue() async {
    _totalValue = await _repo.getCurrentTotalValue();
    notifyListeners();
  }

  Future<void> loadDashboardSummary() async {
    _isLoading = true;
    notifyListeners();

    _totalIncome = await _repo.getTotalIncomeTransactions();
    _totalExpense = await _repo.getTotalExpenseTransactions();
    _totalValue = _totalIncome - _totalExpense;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    _transactions = await _repo.getAllTransactions();
    _totalValue = await _repo.getCurrentTotalValue();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await _repo.addTransaction(tx);
    await loadTransactions();
    await loadTotalValue();
  }

  Future<void> loadTransactionsByRange(String range) async {
    _isLoading = true;
    notifyListeners();

    _transactions = await _repo.getTransactionsByRange(range);
    _chartData = _generateChartData(range, _transactions);

    _isLoading = false;
    notifyListeners();
  }

  // =============================
  // FILTER: Apply & Reset

  Future<void> applyFilter() async {
    _isLoading = true;
    notifyListeners();

    _transactions = await _repo.getTransactionsFiltered(
      sentiment: _sentiment,
      category: _selectedCategory,
      startDate: _startDate,
      endDate: _endDate,
    );

    _isLoading = false;
    notifyListeners();
  }

  void resetFilter() {
    _sentiment = 0;
    _selectedCategory = null;
    _startDate = null;
    _endDate = null;
    _transactions = [];
    notifyListeners();
  }

  void resetFilterHistory() {
    _selectedCategory = null;
    _startDate = null;
    _endDate = null;
    loadTransactions(); // muat ulang semua transaksi
    notifyListeners();
  }

  // =============================
  // Chart generation helper

  List<FlSpot> _generateChartData(String range, List<TransactionModel> txs) {
    DateTime now = DateTime.now();

    if (range == "1D") {
      List<double> values = List.filled(24, 0);
      for (var tx in txs) {
        values[tx.date.hour] += tx.amount;
      }
      return List.generate(24, (i) => FlSpot(i.toDouble(), values[i]));
    } else if (range == "1W") {
      List<double> values = List.filled(7, 0);
      for (var tx in txs) {
        int diff = now.difference(tx.date).inDays;
        if (diff < 7) {
          values[6 - diff] += tx.amount;
        }
      }
      return List.generate(7, (i) => FlSpot(i.toDouble(), values[i]));
    } else if (range == "1M") {
      List<double> values = List.filled(4, 0);
      for (var tx in txs) {
        int diffDays = now.difference(tx.date).inDays;
        int weekIndex = (diffDays / 7).floor();
        if (weekIndex < 4) {
          values[3 - weekIndex] += tx.amount;
        }
      }
      return List.generate(4, (i) => FlSpot(i.toDouble(), values[i]));
    } else if (range == "1Y") {
      List<double> values = List.filled(12, 0);
      for (var tx in txs) {
        int monthDiff =
            (now.year - tx.date.year) * 12 + (now.month - tx.date.month);
        if (monthDiff < 12) {
          values[11 - monthDiff] += tx.amount;
        }
      }
      return List.generate(12, (i) => FlSpot(i.toDouble(), values[i]));
    } else {
      return [];
    }
  }

  Future<void> loadChartSummaryByYear(int year) async {
    _isLoading = true;
    notifyListeners();

    final txs = await _repo.getTransactionsByYear(year);

    // Pisahkan income dan expense
    List<TransactionModel> incomeTxs =
        txs.where((tx) => tx.type == 'income').toList();
    List<TransactionModel> expenseTxs =
        txs.where((tx) => tx.type == 'expense').toList();

    // Buat chart data bulanan
    _chartDataIncome = _generateYearlyChart(incomeTxs);
    _chartDataExpense = _generateYearlyChart(expenseTxs);

    _isLoading = false;
    notifyListeners();
  }

  List<FlSpot> _generateYearlyChart(List<TransactionModel> txs) {
    List<double> values = List.filled(12, 0);
    for (var tx in txs) {
      values[tx.date.month - 1] += tx.amount;
    }
    return List.generate(12, (i) => FlSpot((i + 1).toDouble(), values[i]));
  }

// getter
  List<FlSpot> get chartDataIncome => _chartDataIncome;
  List<FlSpot> get chartDataExpense => _chartDataExpense;
}
