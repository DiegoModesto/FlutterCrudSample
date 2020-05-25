import 'package:crudsample/data/Dummy_users.dart';
import 'package:crudsample/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  final Map<String, UserModel> _items = {...Dummy_users};
  final Uuid uuid = Uuid();

  List<UserModel> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  UserModel byIndex(int index) {
    return _items.values.elementAt(index);
  }

  void put(UserModel user) {
    if (user == null) return;

    //EDIT
    if (user.id != null &&
        user.id.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      _items.update(user.id, (value) => user);
    } else { //CREATE
      final String id = uuid.v4();
      _items.putIfAbsent(
          id,
          () => UserModel(
              id: id,
              name: user.name,
              email: user.email,
              avatarUrl: user.avatarUrl));
    }

    notifyListeners();
  }

  void delete(UserModel user) {
    if(user != null && user.id != null) {
      this._items.removeWhere((item, value) => value.id == user.id);
      notifyListeners();
    }
  }
}
