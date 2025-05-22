import 'package:flutter/material.dart';
import 'package:qonnect/utils/helpers/common.dart';

class ChatModel {
  String name;
  String icon;
  bool isGroup;
  String time;
  String currentMessage;
  int id;
  int? isSender;
  ChatModel({
    required this.name,
    required this.icon,
    required this.isGroup,
    required this.time,
    required this.currentMessage,
    required this.id,
    this.isSender,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'isGroup': isGroup,
      'time': time,
      'currentMessage': currentMessage,
      'id': id,
    };
  }

  // Create ChatModel from Map
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      name: json['name'],
      icon: json['icon'] ?? "",
      isGroup: json['isGroup'] ?? false,
      time: modifyDateTimeValue(json['timeStamp']).toString() ,
      currentMessage: json['lastMsg'] ?? "",
      id: json['recID'],
      isSender: json['isSender'],
    );
  }
}

class OwnUserDetailModel {
  String name;
  String icon;
  int id;
  OwnUserDetailModel({
    required this.name,
    required this.icon,
    required this.id,
  });
}


class OwnUserDetailModelProvider with ChangeNotifier{
 late final OwnUserDetailModel ownUserDetailModel;

 void createOwnerInfoObject(String name, String icon, int id) {
  ownUserDetailModel = OwnUserDetailModel(icon: icon, id: id, name: name);
  notifyListeners();
 }
}