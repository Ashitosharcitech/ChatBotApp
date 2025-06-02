// import 'dart:async';

// import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_event.dart';
// import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'chat_event.dart';
// // import 'chat_state.dart';

// class ChattingBloc extends Bloc<ChattingEvent, ChattingState> {
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//     StreamSubscription? _chatSubscription;

//   //  Stream<QuerySnapshot>? _chatStream;

//   ChattingBloc() : super(ChatLoading()) {
//     on<LoadMessagesEvent>(_onLoadMessages);
//     on<SendMessageEvent>(_onSendMessage);
//     on<MessagesUpdated>(_onMessagesUpdated);
//   }

//   Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChattingState> emit) async {
//     emit(ChatLoading());

//     try {
//       final snapshot = await _firestore
//           .collection('chats')
//           .doc(event.chatId)
//           .collection('messages')
//           .orderBy('timestamp')
//           .get();

//       final messages = snapshot.docs.map((doc) => doc.data()).toList();

//       emit(ChatLoaded(messages.cast<Map<String, dynamic>>()));
//     } catch (e) {
//       emit(ChatError('Failed to load messages: $e'));
//     }
//   }

//   Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChattingState> emit) async {
//     try {
//       await _firestore.collection('chats').doc(event.chatId).collection('messages').add({
//         'text': event.text,
//         'senderId': event.senderId,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       add(LoadMessagesEvent(event.chatId));
//     } catch (e) {
//       emit(ChatError('Failed to send message: $e'));
//     }
//   }
// }


import 'dart:async';

import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_event.dart';
import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChattingBloc extends Bloc<ChattingEvent, ChattingState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _chatSubscription;

  ChattingBloc() : super(ChatLoading()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MessagesUpdated>(_onMessagesUpdated);
  }

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChattingState> emit) async {
    emit(ChatLoading());

    // Cancel previous stream (if any)
    _chatSubscription?.cancel();

    // Listen to real-time changes
    _chatSubscription = _firestore
        .collection('chats')
        .doc(event.chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      final messages = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      add(MessagesUpdated(messages));
    });
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChattingState> emit) async {
    try {
      await _firestore
          .collection('chats')
          .doc(event.chatId)
          .collection('messages')
          .add({
        'text': event.text,
        'senderId': event.senderId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      // No need to manually reload messages – snapshots stream will auto-update
    } catch (e) {
      emit(ChatError('Failed to send message: $e'));
    }
  }

  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChattingState> emit) {
    emit(ChatLoaded(event.messages));
  }

  @override
  Future<void> close() {
    _chatSubscription?.cancel();
    return super.close();
  }
}
