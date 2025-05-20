// import 'package:chat_bot_app/Blocss/chat_bloc.dart';
// import 'package:chat_bot_app/Blocss/chat_event.dart';
// import 'package:chat_bot_app/Blocss/chat_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import '../utils/text_utils.dart'; // adjust the path if needed

// class ChatScreen extends StatefulWidget {
//   final TextEditingController _controller = TextEditingController();

//  const ChatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("ChatBot App")),
//       body: Column(
//         children: [
//           Expanded(
//             child: BlocBuilder<ChatBloc, ChatState>(
//               builder: (context, state) {
//                 if (state is ChatInitial) {
//                   return const Center(child: Text("What Can I Help You"));
//                 } else if (state is ChatLoaded || state is ChatLoading) {
//                   final messages = state is ChatLoaded ? state.messages : (state as ChatLoading).messages;

//                   return Column(
//                     children: [
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: messages.length,
//                           itemBuilder: (context, index) {
//                             final message = messages[index];
//                             return Align(
//                               alignment:
//                                   message.isUser
//                                       ? Alignment.centerRight
//                                       : Alignment.centerLeft,
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(
//                                   vertical: 5,
//                                   horizontal: 10,
//                                 ),
//                                 padding: const EdgeInsets.all(10),

//                                 decoration: BoxDecoration(
//                                   color:
//                                       message.isUser
//                                           ? Colors.blue[100]
//                                           : const Color.fromARGB(
//                                             250,
//                                             250,
//                                             250,
//                                             250,
//                                           ),
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 child:
//                                     message.isUser
//                                         ? Text(message.text)
//                                         : MarkdownBody(
//                                           data: highlightImportantWords(
//                                             message.text,
//                                           ),
//                                           styleSheet: MarkdownStyleSheet(
//                                             p: const TextStyle(fontSize: 16),
//                                             strong: const TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       if (state is ChatLoading)
//                         const Padding(
//                           padding: EdgeInsets.all(10),
//                           child: CircularProgressIndicator(),
//                         ),
//                     ],
//                   );
//                 } else if (state is ChatError) {
//                   return Center(child: Text("Error: ${state.message}"));
//                 }
//                 return const SizedBox.shrink();
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: const InputDecoration(
//                       hintText: "Type your message...",
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     final text = _controller.text.trim();
//                     if (text.isNotEmpty) {
//                       context.read<ChatBloc>().add(SendMessageEvent(text));
//                       _controller.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





import 'package:chat_bot_app/Blocss/chat_bloc.dart';
import 'package:chat_bot_app/Blocss/chat_event.dart';
import 'package:chat_bot_app/Blocss/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../utils/text_utils.dart'; // adjust the path if needed

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ChatBot App")),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded || state is ChatLoading) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatInitial) {
                  return const Center(child: Text("What Can I Help You"));
                } else if (state is ChatLoaded || state is ChatLoading) {
                  final messages = state is ChatLoaded ? state.messages : (state as ChatLoading).messages;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            return Align(
                              alignment:
                                  message.isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      message.isUser
                                          ? Colors.blue[100]
                                          : const Color.fromARGB(248, 225, 223, 223),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: message.isUser
                                    ? Text(message.text)
                                    : MarkdownBody(
                                        data: highlightImportantWords(
                                          message.text,
                                        ),
                                        styleSheet: MarkdownStyleSheet(
                                          p: const TextStyle(fontSize: 16),
                                          strong: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (state is ChatLoading)
                        const Padding(
                          padding: EdgeInsets.all(220),
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
                      hintText: "Type your message...",
                    ),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
