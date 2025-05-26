import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:qonnect/models/OwnUserDetialsModel.dart';
import 'package:qonnect/models/chat/chat_model.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_bloc.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_events.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_states.dart';
import 'package:qonnect/service_locators/locators.dart';

class IndividualPage extends StatefulWidget {
  final ChatModel chatModel;
  const IndividualPage({super.key, required this.chatModel});

  @override
  _IndividualPageState createState() {
    return _IndividualPageState();
  }
}

class _IndividualPageState extends State<IndividualPage> {
  final TextEditingController _messageController = TextEditingController();
  OwnUserDetailModel get sourceChat => getIt<OwnUserDetailModel>();

  @override
  void initState() {
    super.initState();
    log(sourceChat.toJson().toString(), name: "Source Chat");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              MessageBloc()..add(
                LoadMessages(
                  sourceChat.id.toString(),
                  widget.chatModel.id.toString(),
                ),
              ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              CircleAvatar(child: Text(widget.chatModel.name[0].toUpperCase())),
              const SizedBox(width: 10),
              Text(
                widget.chatModel.name,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [audioCallButton(), videoCallButton(), buildPopupMenu()],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                    if (state is MessagesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MessagesLoaded) {
                      return ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          // Your message UI building logic
                          return Scaffold();
                        },
                      );
                    } else if (state is MessageError) {
                      return Center(child: Text(state.error));
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
              // Message input field
              messageInputField(),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage(String message) {
    log(message, name: "Message");
    context.read<MessageBloc>().add(
      SendTextMessage(message, sourceChat.id, widget.chatModel.id),
    );
  }

  Widget messageInputField() {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type a message...",
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined),
                  onPressed: () {},
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (builder) => bottomsheet(),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: () => sendMessage(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget audioCallButton() {
    return IconButton(
      icon: const Icon(Icons.call, color: Colors.white),
      onPressed: () {},
    );
  }

  Widget videoCallButton() {
    return IconButton(
      icon: const Icon(Icons.videocam, color: Colors.white),
      onPressed: () {},
    );
  }

  Widget buildPopupMenu() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'block') {
          log('Block user');
        } else if (value == 'report') {
          log('Report user');
        }
      },
      itemBuilder:
          (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'block',
              child: Text('Block User'),
            ),
            const PopupMenuItem<String>(
              value: 'report',
              child: Text('Report User'),
            ),
          ],
      icon: const Icon(Icons.more_vert, color: Colors.white),
    );
  }

  Widget bottomsheet() {
    return SafeArea(
      child: SizedBox(
        height: 400,
        width: MediaQuery.of(context).size.width,
        child: Card(
          margin: const EdgeInsets.all(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconcreation(
                      Icons.insert_drive_file,
                      Colors.indigo,
                      "Document",
                      () {},
                    ),
                    const SizedBox(width: 40),
                    iconcreation(
                      Icons.camera_alt,
                      Colors.pink,
                      "Camera",
                      () {},
                    ),
                    const SizedBox(width: 40),
                    iconcreation(
                      Icons.insert_photo,
                      Colors.purple,
                      "Gallery",
                      () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconcreation(Icons.headset, Colors.orange, "Audio", () {}),
                    const SizedBox(width: 40),
                    iconcreation(Icons.videocam, Colors.cyan, "Video", () {}),
                    const SizedBox(width: 40),
                    iconcreation(
                      Icons.location_pin,
                      Colors.teal,
                      "Location",
                      () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconcreation(
                      Icons.event,
                      Colors.indigoAccent,
                      "Event",
                      () {},
                    ),
                    const SizedBox(width: 40),
                    iconcreation(Icons.link, Colors.greenAccent, "Link", () {}),
                    const SizedBox(width: 40),
                    iconcreation(Icons.note, Colors.brown, "Note", () {}),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget iconcreation(
    IconData icon,
    Color color,
    String text,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icon, size: 29, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
