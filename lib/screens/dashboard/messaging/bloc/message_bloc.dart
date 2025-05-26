import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_events.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_states.dart';
import 'package:qonnect/service_locators/locators.dart';
import 'package:qonnect/services/socket_connection/socket_service.dart';
import 'package:qonnect/utils/LocalDB/local_db.dart';
import 'package:uuid/data.dart';
import 'package:uuid/rng.dart';
import 'package:uuid/uuid.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendTextMessage>(_onSendTextMessage);
    on<SendFileMessage>(_onSendFileMessage);
    on<DeleteMessage>(_onDeleteMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    try {
      emit(MessagesLoading()); // Show loading state
      
      final messages = await DBHelper.getMessages(
        event.sourceId,
        event.targetId,
      );
      
      // Ensure consistent ordering - messages should be in chronological order
      final sortedMessages = messages.toList()
        ..sort((a, b) => DateTime.parse(a['timestamp'])
            .compareTo(DateTime.parse(b['timestamp'])));
      
      emit(MessagesLoaded(sortedMessages));
    } catch (e) {
      log("Error loading messages: $e", name: "MessageBloc");
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onSendTextMessage(
    SendTextMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      var uuid = generateUuid();
      
      // Add message to local database first
      await DBHelper.insertMessage(
        event.sourceId.toString(),
        event.targetId.toString(),
        event.message,
        '',
        'text',
        uuid,
        DateTime.now().toIso8601String(),
        '',
        '',
      );

      // Update contacts
      await DBHelper.updateContactsWithLastMsg(
        event.targetId,
        event.name,
        event.message,
        DateTime.now().toIso8601String(),
        1,
      );

      // Send via socket
      getIt<SocketService>().socket.emit('message', {
        'message': event.message,
        "metadata": {"type": "text"},
        "sourceid": event.sourceId,
        "targetid": event.targetId,
        "path": '',
        "uuidId": uuid,
      });

      // Reload messages to show the sent message immediately
      final messages = await DBHelper.getMessages(
        event.sourceId.toString(),
        event.targetId.toString(),
      );
      
      // Ensure consistent ordering
      final sortedMessages = messages.toList()
        ..sort((a, b) => DateTime.parse(a['timestamp'])
            .compareTo(DateTime.parse(b['timestamp'])));
      
      emit(MessagesLoaded(sortedMessages));
      
    } catch (e) {
      log("Error sending message: $e", name: "MessageBloc");
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onSendFileMessage(
    SendFileMessage event,
    Emitter<MessageState> emit,
  ) async {
    // Add file sending implementation
    try {
      var uuid = generateUuid();
      
      // Add message to local database first
      await DBHelper.insertMessage(
        event.sourceId.toString(),
        event.targetId.toString(),
        event.message ?? '',
        event.path ?? '',
        event.fileType ?? 'file',
        uuid,
        DateTime.now().toIso8601String(),
        '',
        '',
      );

      // Send via socket
      getIt<SocketService>().socket.emit('message', {
        'message': event.message ?? '',
        "metadata": {"type": event.fileType ?? 'file'},
        "sourceid": event.sourceId,
        "targetid": event.targetId,
        "path": event.path ?? '',
        "uuidId": uuid,
      });

      // Reload messages
      final messages = await DBHelper.getMessages(
        event.sourceId.toString(),
        event.targetId.toString(),
      );
      
      final sortedMessages = messages.toList()
        ..sort((a, b) => DateTime.parse(a['timestamp'])
            .compareTo(DateTime.parse(b['timestamp'])));
      
      emit(MessagesLoaded(sortedMessages));
      
    } catch (e) {
      log("Error sending file message: $e", name: "MessageBloc");
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      await DBHelper.deleteOneMessage(event.uuid);
      emit(MessageSent()); // Notify that operation completed
    } catch (e) {
      log("Error deleting message: $e", name: "MessageBloc");
      emit(MessageError(e.toString()));
    }
  }

  String generateUuid() {
    var uuid = const Uuid();
    return uuid.v4(config: V4Options(null, CryptoRNG())).toString();
  }
}