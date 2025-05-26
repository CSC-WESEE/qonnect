abstract class MessageEvent {}

class SendTextMessage extends MessageEvent {
  final String message;
  final int sourceId;
  final int targetId;
  final String name;
  
  SendTextMessage(this.message, this.sourceId, this.targetId, this.name);
}

class SendFileMessage extends MessageEvent {
  final String path;
  final String message;
  final int sourceId;
  final int targetId;
  final String fileType;

  SendFileMessage(this.path, this.message, this.sourceId, this.targetId, this.fileType);
}

class LoadMessages extends MessageEvent {
  final String sourceId;
  final String targetId;

  LoadMessages(this.sourceId, this.targetId);
}

class DeleteMessage extends MessageEvent {
  // final String messageId;
  final String uuid;
  
  DeleteMessage(this.uuid);
}