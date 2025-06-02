abstract class ChattingEvent {}

class LoadMessagesEvent extends ChattingEvent {
  final String chatId;
  LoadMessagesEvent(this.chatId);
}

class SendMessageEvent extends ChattingEvent {
  final String chatId;
  final String text;
  final String senderId;
  SendMessageEvent(this.chatId, this.text, this.senderId);
}
class MessagesUpdated extends ChattingEvent{
  final List<Map<String, dynamic>> messages;
  MessagesUpdated(this.messages);
}
