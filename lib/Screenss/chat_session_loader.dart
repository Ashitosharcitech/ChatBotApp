  import 'package:chat_bot_app/Blocss/chat_bot_screen_bloc_file/chat_bloc.dart';
import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

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


//   import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//   import 'package:flutter_bloc/flutter_bloc.dart';
//   import 'package:chat_bot_app/Blocss/chat_bloc.dart';
//   import 'package:chat_bot_app/Blocss/chat_state.dart';
//   import 'package:chat_bot_app/Service/firebase_services.dart';
//   import 'package:chat_bot_app/Screenss/chat_screen.dart';
// class ChatSessionLoader extends StatelessWidget {
//   final String sessionId;
//   const ChatSessionLoader({super.key, required this.sessionId});
// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chat History")),
//       body: FutureBuilder(
//         future: FirebaseService().getSessionMessages(sessionId),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
//           final messages = snapshot.data as List<Map<String, dynamic>>;

//           return ListView.builder(
//             itemCount: messages.length,
//             itemBuilder: (context, index) {
//               final message = messages[index];
//               return ListTile(
//                 title: Text(message['content']),
//                 subtitle: Text(message['sender'] == FirebaseAuth.instance.currentUser!.uid ? 'You' : 'Bot'),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
