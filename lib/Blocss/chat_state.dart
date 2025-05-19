import 'package:chat_bot_app/modelss/message.dart';

import '../modelss/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messages;
  ChatLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}
