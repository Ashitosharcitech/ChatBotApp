// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../modelss/message.dart';


// class FirestoreService {

//   final _chatRef  = FirebaseFirestore.instance.collection('chat_history');

//   Future<void> saveMessage(Message message) async{
//     await _chatRef.add(message.toMap());

//   }


//   Future<List<Message>> getMessages() async {
//     final snapshot = await  _chatRef.orderBy('timeStamp').get();
//     return snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList();

//   }
// }