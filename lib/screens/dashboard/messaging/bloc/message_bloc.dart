import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_events.dart';
import 'package:qonnect/screens/dashboard/messaging/bloc/message_states.dart';
import 'package:qonnect/utils/LocalDB/local_db.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendTextMessage>(_onSendTextMessage);
    on<SendFileMessage>(_onSendFileMessage);
    on<DeleteMessage>(_onDeleteMessage);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<MessageState> emit) async {
    emit(MessagesLoading());
    try {
      final messages = await DBHelper.getMessages(event.sourceId, event.targetId);
      emit(MessagesLoaded(messages));
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onSendTextMessage(SendTextMessage event, Emitter<MessageState> emit) async {
    try {
      // Add your socket.io message sending logic here
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
        ''
      );
      
      add(LoadMessages(event.sourceId.toString(), event.targetId.toString()));
      emit(MessageSent());
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  Future<void> _onSendFileMessage(SendFileMessage event, Emitter<MessageState> emit) async {
    // Add file sending implementation
  }

  Future<void> _onDeleteMessage(DeleteMessage event, Emitter<MessageState> emit) async {
    try {
      await DBHelper.deleteOneMessage(int.parse(event.messageId));
      // Reload messages after deletion
      emit(MessageSent());
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  String generateUuid() {
    // Add UUID generation logic
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}