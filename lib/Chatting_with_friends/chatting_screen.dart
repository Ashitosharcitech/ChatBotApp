import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_bloc.dart';
import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_event.dart';
import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChattingScreen extends StatelessWidget {
  final String friendId;
  final String chatId;

  ChattingScreen({required this.friendId, required this.chatId});

  final TextEditingController _messageController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChattingBloc()..add(LoadMessagesEvent(chatId)),
      child: Scaffold(
        appBar: AppBar(title: Text('Chat')),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChattingBloc, ChattingState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ChatLoaded) {
                    return ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final msg = state.messages[index];
                        final isMe = msg['senderId'] == currentUser!.uid;
                        return Align(
                          alignment:
                              isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue[200] : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(msg['text']),
                          ),
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(child: Text(state.error));
                  } else {
                    return Center(child: Text('No messages'));
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      context.read<ChattingBloc>().add(
                        SendMessageEvent(chatId, message, currentUser!.uid),
                      );
                      _messageController.clear();
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
