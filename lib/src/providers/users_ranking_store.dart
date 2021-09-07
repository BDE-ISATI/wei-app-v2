import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/users_service.dart';

class UsersRankingStore with ChangeNotifier {
  Map<String, User>? _users;

  Future<List<User>> getUsers(String authorization, {bool forceRefresh = false}) async {
    if (forceRefresh) {
      _users = null;
    }

    _users ??= await UsersService.instance.getRankedUsers(authorization);

    return _users!.values.toList();
  } 

  Map<String, User> get users => _users!;
  List<User> get usersList => _users!.values.toList();
}