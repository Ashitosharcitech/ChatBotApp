// // import 'package:chat_bot_app/Bloc_friend/friend_bloc.dart';
// // import 'package:chat_bot_app/Bloc_friend/friend_event.dart';
// // import 'package:chat_bot_app/Bloc_friend/friend_state.dart';
// // import 'package:chat_bot_app/Screenss/chat_screen.dart';
// import 'package:chat_bot_app/Screenss/chat_screen.dart';
// import 'package:chat_bot_app/users/friend_bloc.dart';
// import 'package:chat_bot_app/users/friend_event.dart';
// import 'package:chat_bot_app/users/friend_state.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class FriendListScreen extends StatelessWidget {
//   final currentUser = FirebaseAuth.instance.currentUser!;

//   String generateChatId(String uid1, String uid2) {
//     return uid1.hashCode <= uid2.hashCode ? '$uid1\_$uid2' : '$uid2\_$uid1';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => FriendBloc()..add(LoadFriendsEvent()),
//       child: Scaffold(
//         appBar: AppBar(title: Text('Your Friends')),
//         body: BlocBuilder<FriendBloc, FriendState>(
//           builder: (context, state) {
//             if (state is FriendLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is FriendLoaded) {
//               return ListView.builder(
//                 itemCount: state.friends.length,
//                 itemBuilder: (context, index) {
//                   final friend = state.friends[index];
//                   final chatId = generateChatId(currentUser.uid, friend['uid']);
//                   return ListTile(
//                     title: Text(friend['name']),
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => ChatScreen(
//                           friendId: friend['uid'],
//                           chatId: chatId,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else if (state is FriendError) {
//               return Center(child: Text(state.message));
//             }
//             return Center(child: Text('No friends found.'));
//           },
//         ),
//       ),
//     );
//   }
// }