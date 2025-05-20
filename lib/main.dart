import 'package:chat_bot_app/Blocss/chat_bloc.dart';
import 'package:chat_bot_app/Screenss/chat_screen.dart';
import 'package:chat_bot_app/Service/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const GeminiApp());
}

class GeminiApp extends StatelessWidget {
  const GeminiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini ChatBot',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => ChatBloc(GeminiService()),
        child: ChatScreen(),
      ),
    );
  }
}
