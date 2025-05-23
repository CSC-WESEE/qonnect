import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:qonnect/utils/LocalDB/local_db.dart';

class OwnUserDetailModel {
  String name;
  String email;
  int id;

  // Initialize with default values in constructor
  OwnUserDetailModel({
    this.name = '',
    this.email = '',
    this.id = 0,
  });

  static Future<OwnUserDetailModel> create() async {
    var model = OwnUserDetailModel();
    await model.updateOwnUserModel();
    return model;
  }

  void updateFromJson(Map<String, dynamic> json) {
    try {
      name = json['userName']?.toString() ?? '';
      email = json['email']?.toString() ?? '';
      id = json['userID'] is int ? json['userID'] : 0;
    } catch (e) {
      log('Error parsing user details: $e');
      name = '';
      email = '';
      id = 0;
    }
  }

  Future<void> updateOwnUserModel() async {
    try {
      var res = await DBHelper.getOwnerInfo();
      if (res.isNotEmpty) {
        updateFromJson(res[0]);
      }
    } catch (e) {
      log('Error updating user model: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'id': id};
  }
}