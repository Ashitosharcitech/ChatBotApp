import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestScreen extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;

  void acceptRequest(String requestId, String fromUserId) async {
    final chatId = generateChatId(currentUser!.uid, fromUserId);
    // Update request status
    await FirebaseFirestore.instance.collection('friend_requests').doc(requestId).update({
      'status': 'accepted',
    });

    // Save as friends
    await FirebaseFirestore.instance.collection('friends').add({
      'user1': currentUser!.uid,
      'user2': fromUserId,
      'chatId': chatId,
    });
  }
  void rejectRequest(String requestId) async {
    await FirebaseFirestore.instance.collection('friend_requests').doc(requestId).update({
      'status': 'rejected',
    });
  }

  String generateChatId(String uid1, String uid2) {
  return uid1.hashCode <= uid2.hashCode ? '$uid1\_$uid2' : '$uid2\_$uid1';
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Friend Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('friend_requests')
            .where('to', isEqualTo: currentUser!.uid)
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final requests = snapshot.data!.docs;
          if (requests.isEmpty) {
            return Center(child: Text('No friend requests'));
          }


          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final req = requests[index];
              final fromId = req['from'];
              final from = req['fromName'] ?? 'unknown User';

              return ListTile(
                title: Text('$from'),
                // subtitle: Text('UID: $fromId'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => acceptRequest(req.id, fromId),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text('Accept'),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(onPressed: () => rejectRequest(req.id),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text('Reject'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}



