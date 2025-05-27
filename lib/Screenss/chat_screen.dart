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

import 'dart:math';

import 'package:chat_bot_app/Blocss/chat_bloc.dart';
import 'package:chat_bot_app/Blocss/chat_event.dart';
import 'package:chat_bot_app/Blocss/chat_state.dart';
import 'package:chat_bot_app/Screenss/chat_session_loader.dart';
import 'package:chat_bot_app/Service/firebase_services.dart';
import 'package:chat_bot_app/modelss/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../utils/text_utils.dart'; // adjust the path if needed
import 'package:chat_bot_app/Service/auth_service.dart';

class ChatScreen extends StatefulWidget {
  final String? previousUserMessage;
  final String? previousBotResponse;
  const ChatScreen({
    Key? key,
    this.previousUserMessage,
    this.previousBotResponse, required friendId, required String chatId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAutoScrollEnabled = true;
  bool _showScrollToBottomBtn = false;

  @override
  void initState() {
    super.initState();
    if (widget.previousUserMessage != null &&
        widget.previousBotResponse != null) {
      final chatBloc = context.read<ChatBloc>();
      chatBloc.add(
        LoadPreviousChatEvent(
          sessionId: widget.toString(),
          previousUserMessage: widget.previousUserMessage!,
          previousBotResponse: widget.previousBotResponse!,
        ),
      );
    }
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;

      final position = _scrollController.position;
      final distanceFromBottom = position.maxScrollExtent - position.pixels;

      const threshold = 20.0;

      if (distanceFromBottom > threshold) {
        setState(() {
          _isAutoScrollEnabled = false;
          _showScrollToBottomBtn = true;
        });
      } else {
        setState(() {
          _isAutoScrollEnabled = true;
          _showScrollToBottomBtn = false;
        });
      }
    });
  }

  void _scrollToBottom({bool force = false}) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients && (_isAutoScrollEnabled || force)) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
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
      appBar: AppBar(
        title: const Text("ChatBot App"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.create),
            tooltip: "Start New Chat ",
            onPressed: () {
              context.read<ChatBloc>().add(
                ClearChatEvent(userInput: 'New Chat'),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: FirebaseService().getAllSessions(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final sessions = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                          'All History',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...sessions.map((session) {
                        return Column(
                          children: [
                            ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // tileColor: Colors.grey[100],
                              title: Text(
                                session['title'] ?? 'Unnamed Session',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 20,),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChatSessionLoader(
                                          sessionId: session['sessionId'],
                                        ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
                const Divider(),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () async{
                    await AuthService().signOut();
                    Navigator.of(context).pop();
                    // Optionally navigate to login screen
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                  },
                ),
                )
              ],
            );
          },
        ),
      ),

      body: Stack(
        children: [
          Column(
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
                      final messages =
                          state is ChatLoaded
                              ? state.messages
                              : (state as ChatLoading).messages;

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount:
                            messages.length + (state is ChatLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < messages.length) {
                            final message = messages[index];
                            return Align(
                              alignment:
                                  message.isUser
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      message.isUser
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color:
                                                message.isUser
                                                    ? const Color.fromARGB(
                                                      255,
                                                      220,
                                                      236,
                                                      249,
                                                    )
                                                    : const Color.fromARGB(
                                                      248,
                                                      233,
                                                      231,
                                                      231,
                                                    ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child:
                                              message.isUser
                                                  ? Text(message.text)
                                                  : MarkdownBody(
                                                    data: message.text,
                                                  ),
                                        ),
                                        if (message.isUser)
                                          Positioned(
                                            bottom: -30,
                                            right: -12,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                              tooltip: "Edit message",
                                              onPressed: () {
                                                _controller.text = message.text;
                                                _controller.selection =
                                                    TextSelection.fromPosition(
                                                      TextPosition(
                                                        offset:
                                                            _controller
                                                                .text
                                                                .length,
                                                      ),
                                                    );
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            // Show "Thinking..." during loading
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    248,
                                    233,
                                    231,
                                    231,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Thinking...",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
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
                          _isAutoScrollEnabled = true;
                          _scrollToBottom(force: true);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 🟢 Scroll to bottom button
          if (_showScrollToBottomBtn)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 90),
                child: FloatingActionButton.small(
                  onPressed: () {
                    _isAutoScrollEnabled = true;
                    _scrollToBottom(force: true);
                  },
                  child: const Icon(Icons.arrow_downward),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
