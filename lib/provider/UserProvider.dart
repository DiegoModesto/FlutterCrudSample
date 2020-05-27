import 'dart:convert';

import 'package:crudsample/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final String _baseDbUrl =
      'https://crudsimples-diegomodesto.firebaseio.com/users/';

  Map<String, UserModel> _items;

  UserProvider() {
    if (_items == null) {
      _items = new Map<String, UserModel>();
      this._getFromServer();
    } else if (_items.length == 0) {
      this._getFromServer();
    }
  }

  void _getFromServer() async {
    final response = await http.get('$_baseDbUrl.json');

    Map<String, dynamic> jsonDeserialized = json.decode(response.body);

    jsonDeserialized.forEach((key, value) {
      this._items.putIfAbsent(
          key,
          () => UserModel(
                id: key,
                name: value['name'].toString().trim(),
                email: value['email'].toString().trim(),
                avatarUrl: value['avatarUrl'].toString().trim(),
              ));
    });

    notifyListeners();
  }

  List<UserModel> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  UserModel byIndex(int index) {
    return _items.values.elementAt(index);
  }

  void put(UserModel user) async {
    if (user == null) return;

    //EDIT
    if (user.id != null &&
        user.id.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      await http.patch(
        '$_baseDbUrl${user.id}.json',
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl
        }),
      );

      _items.update(user.id, (value) => user);
    } else {
      //CREATE

      final response = await http.post(
        '$_baseDbUrl.json',
        body: json.encode({
          'name': user.name,
          'email': user.email,
          'avatarUrl': user.avatarUrl
        }),
      );
      final id = json.decode(response.body)['name'];

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

  void delete(UserModel user) async {
    if (user != null && user.id != null) {
      await http.delete('$_baseDbUrl${user.id}.json');

      this._items.removeWhere((item, value) => value.id == user.id);
      notifyListeners();
    }
  }
}
