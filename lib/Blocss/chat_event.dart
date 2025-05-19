abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String userInput;
  SendMessageEvent(this.userInput);
}
