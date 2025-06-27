import 'package:isar/isar.dart';

part 'transaction_model.g.dart';

@Collection()
class TransactionModel {
  Id id = Isar.autoIncrement;

  late double amount;
  late String description;
  late String type;
  
  @Index()
  late DateTime date;

  late String category;

  bool get isIncome => type == 'income';
}
