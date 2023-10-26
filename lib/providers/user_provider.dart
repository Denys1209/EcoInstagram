import 'package:flutter/foundation.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/models/user.dart' as model;

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();

  model.User get getUser => _user!;

  Future<void> refreshUser() async {
    var user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
  
}


