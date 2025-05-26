abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String userInput;
  SendMessageEvent(this.userInput);
}

class TypeBotMessageEvent extends ChatEvent {
  final String fullText;
  TypeBotMessageEvent(this.fullText);
}
class LoadPreviousChatEvent extends ChatEvent {
  final String sessionId;
  final String previousUserMessage;
  final String previousBotResponse;

  LoadPreviousChatEvent({
    required this.sessionId,
    required this.previousUserMessage,
    required this.previousBotResponse,
  });
}



class ClearChatEvent extends ChatEvent {
   final String userInput;
  ClearChatEvent({required this.userInput});
}

class StartNewSessionEvent extends ChatEvent {
  final String title;
  StartNewSessionEvent(this.title);
}

class LoadSessionEvent extends ChatEvent {
  final String sessionId;
  LoadSessionEvent(this.sessionId);
}
