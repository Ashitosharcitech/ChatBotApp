import 'dart:math';

import 'package:chat_bot_app/Blocss/chat_bloc.dart';
import 'package:chat_bot_app/Screenss/chat_screen.dart';
import 'package:chat_bot_app/Service/auth_service.dart';
import 'package:chat_bot_app/Service/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'chat_bloc/chat_bloc.dart';
import 'Service/gemini_service.dart';
// import 'Service/firebase_service.dart';
// import 'screens/chat_screen.dart'; // or whatever your main screen is

import 'package:chat_bot_app/Screenss/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(AppWrapper());
}

class AppWrapper extends StatelessWidget {
  final geminiService = GeminiService();
  final firebaseService = FirebaseService();
  final AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(geminiService, firebaseService),
      child: MaterialApp(
        title: 'ChatBot App',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: _authService.userChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return ChatScreen(friendId: null, chatId: '');
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
