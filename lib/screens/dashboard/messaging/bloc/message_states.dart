abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessagesLoading extends MessageState {}

class MessagesLoaded extends MessageState {
  final List<Map<String, dynamic>> messages;
  
  MessagesLoaded(this.messages);
}

class MessageSent extends MessageState {}

class MessageError extends MessageState {
  final String error;
  
  MessageError(this.error);
}