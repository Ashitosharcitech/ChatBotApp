import 'package:chat_bot_app/Service/gemini_service.dart';
import 'package:chat_bot_app/modelss/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modelss/message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService geminiService;
  List<Message> _messages = [];

  ChatBloc(this.geminiService) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    _messages.add(Message(text: event.userInput, isUser: true));
    emit(ChatLoaded(List.from(_messages)));

    try {
      final response = await geminiService.sendMessage(event.userInput);
      _messages.add(Message(text: response, isUser: false));
      emit(ChatLoaded(List.from(_messages)));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
