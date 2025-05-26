import 'package:chat_bot_app/Service/firebase_services.dart';
import 'package:chat_bot_app/Service/gemini_service.dart';
import 'package:chat_bot_app/modelss/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GeminiService geminiService;
  final FirebaseService firebaseService;
  final List<Message> _messages = [];
  String? _currentSessionId;

  ChatBloc(this.geminiService, this.firebaseService) : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<TypeBotMessageEvent>(_onTypeBotMessage);
    on<LoadPreviousChatEvent>(_onLoadPreviousChat);
    on<ClearChatEvent>(_onClearChat);
  }
  
void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
  // ✅ Only create session on first message
  if (_currentSessionId == null) {
    final title = _generateSessionTitle(event.userInput);
    _currentSessionId = await firebaseService.createSession(title: title);
  }

  _messages.add(Message(text: event.userInput, isUser: true));
  emit(ChatLoaded(List.from(_messages)));
  emit(ChatLoading(List.from(_messages)));

  try {
    final response = await geminiService.sendMessage(event.userInput);
    await firebaseService.saveMessageToSession(
      _currentSessionId!,
      event.userInput,
      response,
    );
    add(TypeBotMessageEvent(response));
  } catch (e) {
    emit(ChatError(e.toString()));
  }
}



  Future<void> _onTypeBotMessage(
    TypeBotMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
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

  void _onLoadPreviousChat(
    LoadPreviousChatEvent event,
    Emitter<ChatState> emit,
  ) {
    _messages.clear();
    _currentSessionId = event.sessionId;
    _messages.add(Message(text: event.previousUserMessage, isUser: true));
    _messages.add(Message(text: event.previousBotResponse, isUser: false));
    emit(ChatLoaded(List.from(_messages)));
  }

  Future<void> _onClearChat(
    ClearChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    _messages.clear();
    _currentSessionId = null;
    emit(ChatInitial());
  }

  void loadMessagesFromSession(
    String sessionId,
    List<Map<String, dynamic>> messages,
  ) {
    _messages.clear();
    _currentSessionId = sessionId;
    for (var msg in messages) {
      _messages.add(Message(text: msg['userMessage'], isUser: true));
      _messages.add(Message(text: msg['botResponse'], isUser: false));
    }
    emit(ChatLoaded(List.from(_messages)));
  }

  void emitCurrentMessages(Emitter<ChatState> emit) {
    emit(ChatLoaded(List.from(_messages)));
  }

  String _generateSessionTitle(String message) {
    return message.length > 30 ? message.substring(0, 30) + '...' : message;
  }
}
