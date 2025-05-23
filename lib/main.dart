import 'package:chat_bot_app/Blocss/chat_bloc.dart';
import 'package:chat_bot_app/Screenss/chat_screen.dart';
import 'package:chat_bot_app/Service/firebase_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'chat_bloc/chat_bloc.dart';
import 'Service/gemini_service.dart';
// import 'Service/firebase_service.dart';
// import 'screens/chat_screen.dart'; // or whatever your main screen is

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final geminiService = GeminiService();
  final firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBloc(geminiService, firebaseService),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatBot App',
        home: ChatScreen(), // or MyHomePage()
      ),
    );
  }
}
