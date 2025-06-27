import 'package:isar/isar.dart';
import 'package:money_tracker_new/helper/isar_service.dart';
import 'package:money_tracker_new/data/models/user_model.dart';

class UserRepository {
  Future<void> addUser(UserModel user) async {
    final isar = await IsarService.getInstance();
    await isar.writeTxn(() async {
      await isar.userModels.put(user);
    });
  }

  Future<UserModel?> getUser() async {
    final isar = await IsarService.getInstance();
    return await isar.userModels.where().findFirst();
  }
}