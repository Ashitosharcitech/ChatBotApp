import 'package:chat_bot_app/Blocss/chat_bot_screen_bloc_file/chat_bloc.dart';
import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_bloc.dart';
import 'package:chat_bot_app/Chatting_with_friends/Chatting_bloc_file/chatting_event.dart';
import 'package:chat_bot_app/Chatting_with_friends/chatting_screen.dart';
import 'package:chat_bot_app/Screenss/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendListScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  String generateChatId(String uid1, String uid2) {
    return uid1.hashCode <= uid2.hashCode ? '$uid1\_$uid2' : '$uid2\_$uid1';
  }

  Future<String> getFriendName(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc['name'] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Friends')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('friends').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          final friends = docs.where((doc) =>
              doc['user1'] == currentUser!.uid || doc['user2'] == currentUser?.uid);

          return ListView(
            children: friends.map((doc) {
              final friendId = doc['user1'] == currentUser!.uid
                  ? doc['user2']
                  : doc['user1'];
              final chatId = generateChatId(currentUser!.uid, friendId);

              return FutureBuilder<String>(
                future: getFriendName(friendId),
                builder: (context, nameSnapshot) {
                  if (!nameSnapshot.hasData) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  return ListTile(
                    title: Text(nameSnapshot.data!), // ✅ Show friend's name
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  BlocProvider(
                            create: (_) => ChattingBloc()..add(LoadMessagesEvent(chatId)),
                            child: ChattingScreen(friendId: friendId, chatId: chatId),
                           
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
