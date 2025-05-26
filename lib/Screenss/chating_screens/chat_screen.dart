// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ChatScreen extends StatefulWidget {
//   final String friendId;
//   final String chatId;

//   ChatScreen({required this.friendId, required this.chatId});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final currentUser = FirebaseAuth.instance.currentUser;

//   void sendMessage() {
//     if (_controller.text.trim().isEmpty) return;
//     FirebaseFirestore.instance
//         .collection('chats')
//         .doc(widget.chatId)
//         .collection('messages')
//         .add({
//       'senderId': currentUser!.uid,
//       'message': _controller.text.trim(),
//       'timestamp': Timestamp.now(),
//     });
//     _controller.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(widget.chatId)
//                   .collection('messages')
//                   .orderBy('timestamp')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return CircularProgressIndicator();
//                 final messages = snapshot.data!.docs;
//                 return ListView.builder(
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];
//                     return ListTile(
//                       title: Text(msg['message']),
//                       subtitle: Text(msg['senderId'] == currentUser!.uid
//                           ? "You"
//                           : "Friend"),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration:
//                         InputDecoration(hintText: "Type a message..."),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: sendMessage,
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
