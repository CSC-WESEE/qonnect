import 'dart:nativewrappers/_internal/vm/lib/developer.dart';

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
    emit(MessagesLoading());
    try {
      getIt<SocketService>().socket.on("message", (data) {
        log("Message received in individual page: $data");
      });
      final messages = await DBHelper.getMessages(
        event.sourceId,
        event.targetId,
      );
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onSendTextMessage(
    SendTextMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      var uuid = generateUuid();
      // Add your socket.io message sending logic here
      getIt<SocketService>().socket.emit('message', {
        'message': event.message,
        "metadata": {"type": "text"},
        "sourceid": event.sourceId,
        "targetid": event.targetId,
        "path": '',
        "uuidId": uuid,
      });

      // Add lastmessage to contacts table
      await DBHelper.updateContactsWithLastMsg(
        event.targetId,
        event.name,
        event.message,
        DateTime.now().toIso8601String(),
        1,
      );
      // Add message to local database
      await DBHelper.insertMessage(
        event.sourceId.toString(),
        event.targetId.toString(),
        event.message,
        '',
        'text',
        generateUuid(),
        DateTime.now().toIso8601String(),
        '',
        '',
      );

      add(LoadMessages(event.sourceId.toString(), event.targetId.toString()));
      emit(MessageSent());
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onSendFileMessage(
    SendFileMessage event,
    Emitter<MessageState> emit,
  ) async {
    // Add file sending implementation
  }

  Future<void> _onDeleteMessage(
    DeleteMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      await DBHelper.deleteOneMessage(event.uuid);
      // Reload messages after deletion
      emit(MessageSent());
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  String generateUuid() {
    var uuid = const Uuid();
    return uuid.v4(config: V4Options(null, CryptoRNG())).toString();
  }
}
