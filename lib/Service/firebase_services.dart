import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference sessionsCollection = FirebaseFirestore.instance
      .collection('chat_sessions'); // <-- FIXED name

  Future<String> createSession({required String title}) async {
    final session = await sessionsCollection.add({
      'title' : title,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return session.id;
  }

  Future<void> saveMessageToSession(
    String sessionId,
    String userMessage,
    String botResponse,
  ) async {
    await sessionsCollection.doc(sessionId).collection('messages').add({
      'userMessage': userMessage,
      'botResponse': botResponse,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllSessions() async {
    final snapshot =
        await sessionsCollection.orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return {
        'sessionId': doc.id,
        'createdAt': data['createdAt'],
        'title':
            data['title'] ?? 'Unnamed Session', // ✅ Pull title from Firestore
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getMessagesFromSession(
    String sessionId,
  ) async {
    final snapshot =
        await sessionsCollection
            .doc(sessionId)
            .collection('messages')
            .orderBy('timestamp')
            .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  getSessionMessages(String sessionId) {}
}
