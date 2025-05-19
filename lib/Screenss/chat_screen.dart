import 'package:chat_bot_app/Blocss/chat_bloc.dart';
import 'package:chat_bot_app/Blocss/chat_event.dart';
import 'package:chat_bot_app/Blocss/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../utils/text_utils.dart'; // adjust the path if needed


class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatScreen({super.key});

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("ChatBot App")),
    body: Column(
      children: [
        Expanded(
          child: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatInitial) {
                return const Center(child: Text("What Can I Help You"));
              } else if (state is ChatLoaded || state is ChatLoading) {
                final messages = state is ChatLoaded
                    ? state.messages
                    : (state as ChatLoading).messages;

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Align(
                            alignment: message.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              // decoration: BoxDecoration(
                              //   color: message.isUser
                              //       ? Colors.blue[100]
                              //       : Colors.green[100],
                              //   borderRadius: BorderRadius.circular(12),
                              // ),
                              child: message.isUser
                                  ? Text(message.text)
                                  : MarkdownBody(
                                      data: highlightImportantWords(message.text),
                                      styleSheet: MarkdownStyleSheet(
                                        p: const TextStyle(fontSize: 16),
                                        strong: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (state is ChatLoading)
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                );
              } else if (state is ChatError) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                      hintText: "Type your message..."),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    context.read<ChatBloc>().add(SendMessageEvent(text));
                    _controller.clear();
                  }
                },
              )
            ],
          ),
        ),
      ],
    ),
  );
}
}