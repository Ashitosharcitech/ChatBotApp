// import 'package:flutter/material.dart';
// import '../modelss/message.dart';

// class HistoryScreen extends StatelessWidget {
//   final List<Message> messages;

//   const HistoryScreen({super.key, required this.messages});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat History')),
//       body: ListView.builder(
//         itemCount: messages.length,
//         itemBuilder: (context, index) {
//           final msg = messages[index];
//           return ListTile(
//             title: Text(
//               msg.text,
//               textAlign: msg.isUser ? TextAlign.right : TextAlign.left,
//             ),
//             subtitle: Text(
//               "${msg.isUser ? "User" : "Bot"} • ${msg.timestamp.toLocal()}",
//               textAlign: msg.isUser ? TextAlign.right : TextAlign.left,
//               style: const TextStyle(fontSize: 12, color: Colors.grey),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
