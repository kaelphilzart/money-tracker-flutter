import 'package:isar/isar.dart';

part 'user_model.g.dart';

@Collection()
class UserModel {
  Id id = Isar.autoIncrement;

  late String name;
}
