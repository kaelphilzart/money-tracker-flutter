import 'package:isar/isar.dart';
import 'package:money_tracker_new/helper/isar_service.dart';
import 'package:money_tracker_new/data/models/transaction_model.dart';

class TransactionRepository {
  Future<void> addTransaction(TransactionModel tx) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() async {
      await isar.transactionModels.put(tx);
    });
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final isar = await IsarService.getInstance();
    return await isar.transactionModels.where().sortByDateDesc().findAll();
  }

  Future<List<TransactionModel>> getTransactionsFiltered({
    int? sentiment,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final isar = await IsarService.getInstance();

    // Start dengan .where(), bukan .filter()
    final query = isar.transactionModels
        .where()
        .filter() // Baru pakai filter di sini
        .optional(sentiment != null, (q) {
      final type = sentiment == 0 ? 'income' : 'expense';
      return q.typeEqualTo(type);
    }).optional(category != null && category.isNotEmpty, (q) {
      return q.categoryEqualTo(category!);
    }).optional(startDate != null, (q) {
      return q.dateGreaterThan(startDate!.subtract(const Duration(seconds: 1)));
    }).optional(endDate != null, (q) {
      return q.dateLessThan(endDate!.add(const Duration(days: 1)));
    }).sortByDateDesc(); 

    return await query.findAll();
  }

// get total income transactions
//---------------------------------------------------------------
  Future<double> getTotalIncomeTransactions() async {
    final isar = await IsarService.getInstance();
    final incomeTransactions =
        await isar.transactionModels.filter().typeEqualTo("income").findAll();

    return incomeTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + tx.amount,
    );
  }

//get total expense transactions
//---------------------------------------------------------------
  Future<double> getTotalExpenseTransactions() async {
    final isar = await IsarService.getInstance();
    final expenseTransactions =
        await isar.transactionModels.filter().typeEqualTo("expense").findAll();

    return expenseTransactions.fold<double>(
      0.0,
      (sum, tx) => sum + tx.amount,
    );
  }

// Total Value saat ini 
//---------------------------------------------------------------
Future<double> getCurrentTotalValue() async {
  final totalIncome = await getTotalIncomeTransactions();
  final totalExpense = await getTotalExpenseTransactions();

  return totalIncome - totalExpense;
}

  // Fungsi baru untuk ambil transaksi berdasarkan rentang waktu
  Future<List<TransactionModel>> getTransactionsByRange(String range) async {
    final isar = await IsarService.getInstance();
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (range) {
      case "1D":
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case "1W":
        startDate = now.subtract(const Duration(days: 7));
        break;
      case "1M":
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case "1Y":
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = DateTime(now.year, now.month, now.day);
    }

    final txs = await isar.transactionModels
        .filter()
        .dateGreaterThan(startDate, include: true)
        .sortByDateDesc()
        .findAll();

    return txs;
  }

  Future<List<TransactionModel>> getTransactionsByYear(int year) async {
  final isar = await IsarService.getInstance();
  final start = DateTime(year);
  final end = DateTime(year + 1).subtract(const Duration(milliseconds: 1));

  return await isar.transactionModels
      .filter()
      .dateBetween(start, end)
      .sortByDate()
      .findAll();
}


}
