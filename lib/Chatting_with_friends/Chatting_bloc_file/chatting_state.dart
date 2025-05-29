abstract class ChattingState {}

class ChatInitial extends ChattingState {}

class ChatLoading extends ChattingState {}

class ChatLoaded extends ChattingState {
  final List<Map<String, dynamic>> messages;
  ChatLoaded(this.messages);
}

class ChatError extends ChattingState {
  final String error;
  ChatError(this.error);
}
