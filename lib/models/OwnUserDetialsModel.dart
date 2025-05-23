import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qonnect/service_locators/locators.dart';
import 'package:qonnect/utils/LocalDB/local_db.dart';

class OwnUserDetailModel {
 late String name;
 late String email;
 late int id;

   OwnUserDetailModel.fromJson(Map<String, dynamic> json) {
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

   void updateOwnUserModel() async {
    var res = await DBHelper.getOwnerInfo();
    log(res.toString(), name: "RES from DB helper");
    OwnUserDetailModel.fromJson(res[0]);
    
  }

  

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'id': id};
  }

  OwnUserDetailModel() {
    log(" OwnUserDetailModel constructor called");
    updateOwnUserModel();
  }
}

class OwnUserDetailModelProvider with ChangeNotifier {
  late final OwnUserDetailModel ownUserDetailModel;
}
