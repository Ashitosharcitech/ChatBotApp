import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat_history');

  Future<void> saveMessage(String userMessage, String botResponse) async {
    await chatCollection.add({
      'userMessage': userMessage,
      'botResponse': botResponse,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getChatHistory() async {
    final snapshot = await chatCollection.orderBy('timestamp').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }
}
