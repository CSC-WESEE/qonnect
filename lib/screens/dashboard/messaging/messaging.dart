import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qonnect/models/chat/chat_model_repository.dart';
import 'package:qonnect/routes/router.dart';
import 'package:qonnect/routes/routes.dart';
import 'package:qonnect/service_locators/locators.dart';

class Messaging extends StatefulWidget {
  const Messaging({super.key});

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  late final ChatModelRepository chatModelRepo;

  @override
  void initState() {
    super.initState();
    chatModelRepo = getIt<ChatModelRepository>();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, __) {
        return ListenableBuilder(
          listenable: chatModelRepo,
          builder: (context, _) {
            return (Platform.isLinux || __ == Orientation.landscape)
                ? buildMessageScreenForLandscape()
                : buildMessageScreenForPortrait();
          },
        );
      },
    );
  }

  Widget buildMessageScreenForPortrait() {
    return Scaffold(
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          context.read<RouterHandler>().router.push(Routes.users);
        },
        child: Icon(Icons.perm_contact_cal_outlined),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: chatModelRepo.chatModels.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async {
              
            },
            child: ListTile(
              title: Text(chatModelRepo.chatModels[index].name),
              subtitle: Text("Hi"),
            ),
          );
        },

        // Display the contact information
      ),
    );
  }

  Widget buildMessageScreenForLandscape() {
    return Row(
      children: [
        // Left Sidebar
        Container(
          width: 250,
          color: const Color(0xFF242424),
          child: Column(
            children: [
              // Sidebar Header
              Container(
                padding: const EdgeInsets.all(16),
                child:  Row(
                  children: [
                    Text(
                      'Team Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                          context.read<RouterHandler>().router.push(Routes.users);
                      },
                      child: Icon(Icons.perm_contact_cal_outlined, color: Colors.white,)),
                  ],
                ),
              ),

              // Sidebar Items
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Chats and Channels',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              // Add more chat items here
              ListView.builder(
                shrinkWrap: true,
                itemCount: chatModelRepo.chatModels.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {},
                    child: ListTile(
                      textColor: Colors.white,
                      title: Text(chatModelRepo.chatModels[index].name),
                      subtitle: Text("Hi"),
                    ),
                  );
                },

                // Display the contact information
              ),
            ],
          ),
        ),
        // Main Chat Area
        Expanded(
          child: Column(
            children: [
              // Chat Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text('H'),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'General',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Chat Messages Area
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text('Chat messages will appear here'),
                  ),
                ),
              ),
              // Message Input
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "What's on your mind",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(icon: const Icon(Icons.send), onPressed: () {}),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
