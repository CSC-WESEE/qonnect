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
  OwnUserDetailModel get sourceChat => getIt<OwnUserDetailModel>();

  @override
  void initState() {
    // TODO: implement initState
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
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state) {
          if (state is MessagesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MessagesLoaded) {
            return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                // Your message UI building logic
                return Scaffold();
              },
            );
          }

          if (state is MessageError) {
            return Center(child: Text(state.error));
          }

          return Scaffold();
        },
      ),
    );
  }

  void sendMessage(String message) {
    context.read<MessageBloc>().add(
      SendTextMessage(message, sourceChat.id, widget.chatModel.id),
    );
  }
}
