import 'package:flutter/foundation.dart';
import 'package:money_tracker_new/data/models/user_model.dart';
import 'package:money_tracker_new/data/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repo = UserRepository();

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> addUser(UserModel user) async {
    _isLoading = true;
    notifyListeners();
    await _repo.addUser(user);
    _user = user;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();
    _user = await _repo.getUser();
    _isLoading = false;
    notifyListeners();
  }
}