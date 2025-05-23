import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:qonnect/models/chat/chat_model.dart';
import 'package:qonnect/utils/LocalDB/local_db.dart';

class ChatModelRepository extends ChangeNotifier {
  List<ChatModel> chatModels = [];

  ChatModel removeSelectedId(int index) {
    return chatModels.removeAt(index);
  }

  List<Map<String, dynamic>> toJson() {
    return chatModels.map((chat) => chat.toJson()).toList();
  }

  void fromJson(List<dynamic> jsonList) {
    chatModels = jsonList.map((json) => ChatModel.fromJson(json)).toList();
  }

  void updateChatModelRepo(
    String name,
    int id, [
    String? icon,
    String? timeStamp,
    String? currentMsg,
  ]) async {
    bool userExists = chatModels.any((element) => element.id == id);
    log(userExists.toString(), name: "User Exists");

    if (!userExists) {
      chatModels.add(
        ChatModel(
          name: name,
          icon: icon ?? "",
          isGroup: false,
          time: timeStamp ?? "",
          currentMessage: currentMsg ?? "Hi",
          id: id,
        ),
      );

      await DBHelper.insertContact(name, id);
      notifyListeners(); // Add this line to notify listeners
    }
  }
}
