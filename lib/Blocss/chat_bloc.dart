import 'package:chat_bot_app/Service/firebase_services.dart';
import 'package:chat_bot_app/Service/gemini_service.dart';
// import 'package:chat_bot_app/Service/firebase_service.dart';
import 'package:chat_bot_app/modelss/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modelss/message.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService geminiService;
    final FirebaseService firebaseService;
  final List<Message> _messages = [];

  ChatBloc(this.geminiService, this.firebaseService) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<TypeBotMessageEvent>(_onTypeBotMessage);

     on<LoadPreviousChatEvent>((event, emit) {
      _messages.clear();
      _messages.add(Message(text: event.userInput, isUser: true));
      _messages.add(Message(text: event.botResponse, isUser: false));
      emit(ChatLoaded(List.from(_messages)));
    });
  }

  

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    _messages.add(Message(text: event.userInput, isUser: true));
    emit(ChatLoaded(List.from(_messages)));

    emit(ChatLoading(List.from(_messages)));

    try {
      final response = await geminiService.sendMessage(event.userInput);
       await firebaseService.saveMessage(event.userInput, response);
      add(TypeBotMessageEvent(response));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onTypeBotMessage(
    TypeBotMessageEvent event, Emitter<ChatState> emit) async {
    String currentText = '';
    for (int i = 0; i < event.fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      currentText += event.fullText[i];

      if (_messages.isNotEmpty && !_messages.last.isUser) {
        _messages.removeLast();
      }

      _messages.add(Message(text: currentText, isUser: false));
      emit(ChatLoaded(List.from(_messages)));
    }
  }
}