import 'package:flutter/material.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  const UserModel({
    this.id,
    @required this.name,
    @required this.email,
    this.avatarUrl
  });
}