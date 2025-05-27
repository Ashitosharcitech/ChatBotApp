import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserListScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  void sendFriendRequest(String toUserId) {
    FirebaseFirestore.instance.collection('friend_requests').add({
      'from': currentUser!.uid,
      'to': toUserId,
      'status': 'pending',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Users')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              if (user.id == currentUser!.uid) return Container();
              return ListTile(
                title: Text(user['name']),
                trailing: ElevatedButton(
                  onPressed: () => sendFriendRequest(user.id),
                  child: Text('Send Request'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
