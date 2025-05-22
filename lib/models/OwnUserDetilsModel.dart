import 'package:flutter/material.dart';

class OwnUserDetailModel {
  String name;
  String email;
  int id;
  OwnUserDetailModel({
    required this.name,
    required this.email,
    required this.id,
  });
}

class OwnUserDetailModelProvider with ChangeNotifier {
  late final OwnUserDetailModel ownUserDetailModel;

  void createOwnerInfoObject(String name, String email, int id) {
    ownUserDetailModel = OwnUserDetailModel(email: email, id: id, name: name);
    notifyListeners();
  }
}
