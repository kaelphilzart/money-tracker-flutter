import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:money_tracker_new/data/models/transaction_model.dart';
import 'package:money_tracker_new/data/models/user_model.dart';

class IsarService {
  static Isar? _isar; // ✅ Singleton instance

  static Future<Isar> getInstance() async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        TransactionModelSchema,
        UserModelSchema,
      ],
      directory: dir.path,
      inspector: true,
    );

    return _isar!;
  }
}
