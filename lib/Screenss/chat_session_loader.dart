  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:chat_bot_app/Blocss/chat_bloc.dart';
  import 'package:chat_bot_app/Blocss/chat_state.dart';
  import 'package:chat_bot_app/Service/firebase_services.dart';
  import 'package:chat_bot_app/Screenss/chat_screen.dart';
class ChatSessionLoader extends StatelessWidget {
  final String sessionId;
  const ChatSessionLoader({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FirebaseService().getMessagesFromSession(sessionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        final messages = snapshot.data!;
        final chatBloc = context.read<ChatBloc>();

        chatBloc.loadMessagesFromSession(sessionId, messages);

        return const ChatScreen(friendId: null, chatId: '',);// ✅ Stateless — relies on bloc now
      },
    );
  }
}
