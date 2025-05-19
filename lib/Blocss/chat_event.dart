abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String userInput;
  SendMessageEvent(this.userInput);
}


class TypeBotMessageEvent extends ChatEvent {
  final String fullText;
  TypeBotMessageEvent(this.fullText);
}
