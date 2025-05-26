import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:qonnect/models/OwnUserDetialsModel.dart';
import 'package:qonnect/models/chat/chat_model.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_bloc.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_events.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_states.dart';
import 'package:qonnect/screens/dashboard/messaging/own_message_card.dart';
import 'package:qonnect/screens/dashboard/messaging/reply_message_card.dart';
import 'package:qonnect/service_locators/locators.dart';
import 'package:qonnect/services/socket_connection/socket_service.dart';

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
  final ScrollController _scrollController = ScrollController();
  late MessageBloc _messageBloc;
  
  OwnUserDetailModel get sourceChat => getIt<OwnUserDetailModel>();

  @override
  void initState() {
    super.initState();
    log(sourceChat.toJson().toString(), name: "Source Chat");
    
    // Initialize the bloc
    _messageBloc = MessageBloc();
    
    // Load initial messages
    _messageBloc.add(
      LoadMessages(
        sourceChat.id.toString(),
        widget.chatModel.id.toString(),
      ),
    );
    
    // Set up socket listener
    _setupSocketListener();
  }

  void _setupSocketListener() {
    getIt<SocketService>().socket.on("message", (data) async {
      log("Socket message received: $data", name: "Socket");
      
      // Check if the message is for this conversation
      if (data['targetid'].toString() == widget.chatModel.id.toString() ||
          data['sourceid'].toString() == widget.chatModel.id.toString()) {
        
        // Only reload if the message is from the other user (to avoid duplicate on send)
        if (data['sourceid'].toString() != sourceChat.id.toString()) {
          _messageBloc.add(
            LoadMessages(
              sourceChat.id.toString(),
              widget.chatModel.id.toString(),
            ),
          );
          
          // Auto-scroll to bottom when receiving new message
          _scrollToBottom();
        }
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>.value(
      value: _messageBloc,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocConsumer<MessageBloc, MessageState>(
                  listener: (context, state) {
                    // Auto-scroll when messages are loaded
                    if (state is MessagesLoaded) {
                      _scrollToBottom();
                    }
                  },
                  builder: (context, state) {
                    if (state is MessagesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MessagesLoaded) {
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: false,
                        shrinkWrap: true,
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          if (message['sender'] == sourceChat.id.toString()) {
                            return OwnMessageCard(
                              message: message['message'],
                              time: message['timestamp'].substring(11, 16),
                              messageStatus:
                                  message['messageStatus'] ??
                                  MessageStatus.sent,
                              emojiReaction: message['message_reaction'] ?? "",
                            );
                          } else {
                            return ReplyCard(
                              emojiReaction: message['message_reaction'],
                              message: message['message'],
                              time: message['timestamp'].substring(11, 16),
                            );
                          }
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

  @override
  void dispose() {
    // Clean up socket listener
    getIt<SocketService>().socket.off("message");
    _scrollController.dispose();
    _messageBloc.close();
    super.dispose();
  }

  void sendMessage(String message) {
    log(message, name: "Message");
    _messageBloc.add(
      SendTextMessage(
        message,
        sourceChat.id,
        widget.chatModel.id,
        widget.chatModel.name,
      ),
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
              onPressed: () {
                if (_messageController.text.trim().isNotEmpty) {
                  final message = _messageController.text;
                  _messageController.clear();
                  _messageBloc.add(
                    SendTextMessage(
                      message,
                      sourceChat.id,
                      widget.chatModel.id,
                      widget.chatModel.name,
                    ),
                  );
                }
              },
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
                buildFirstRow(),
                const SizedBox(height: 30),
                buildSecondRow(),
                const SizedBox(height: 30),
                buildThirdRow(),
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

  Widget buildFirstRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconcreation(
          Icons.insert_drive_file,
          Colors.indigo,
          "Document",
          documentSharing,
        ),
        const SizedBox(width: 40),
        iconcreation(
          Icons.camera_alt,
          Colors.pink,
          "Camera",
          imageSharingUsingCamera,
        ),
        const SizedBox(width: 40),
        iconcreation(
          Icons.insert_photo,
          Colors.purple,
          "Gallery",
          imageSharingUsingGallery,
        ),
      ],
    );
  }

  Widget buildSecondRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconcreation(Icons.headset, Colors.orange, "Audio", audioSharing),
        const SizedBox(width: 40),
        iconcreation(Icons.videocam, Colors.cyan, "Video", videoSharing),
        const SizedBox(width: 40),
        iconcreation(
          Icons.location_pin,
          Colors.teal,
          "Location",
          locationSharing,
        ),
      ],
    );
  }

  Widget buildThirdRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconcreation(Icons.event, Colors.indigoAccent, "Event", eventSharing),
        const SizedBox(width: 40),
        iconcreation(Icons.link, Colors.greenAccent, "Link", linkSharing),
        const SizedBox(width: 40),
        iconcreation(Icons.note, Colors.brown, "Note", noteSharing),
      ],
    );
  }

  void documentSharing() {
    log("Document sharing clicked");
  }

  void imageSharingUsingCamera() {
    log("Image sharing using camera clicked");
  }

  void imageSharingUsingGallery() {
    log("Image sharing using gallery clicked");
  }

  void audioSharing() {
    log("Audio sharing clicked");
  }

  void videoSharing() {
    log("Video sharing clicked");
  }

  void locationSharing() {
    log("Location sharing clicked");
  }

  void eventSharing() {
    log("Event sharing clicked");
  }

  void linkSharing() {
    log("Link sharing clicked");
  }

  void noteSharing() {
    log("Note sharing clicked");
  }
}