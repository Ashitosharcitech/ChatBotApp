import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'friend_event.dart';
import 'friend_state.dart';

class FriendBloc extends Bloc<FriendEvent, FriendState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FriendBloc() : super(FriendInitial()) {
    on<LoadFriendsEvent>(_onLoadFriends);
    on<AddFriendEvent>(_onAddFriend);
  }

  Future<void> _onLoadFriends(LoadFriendsEvent event, Emitter<FriendState> emit) async {
    emit(FriendLoading());
    try {
      final currentUser = _auth.currentUser!;
      final snapshot = await _firestore.collection('friends').get();
      final friendDocs = snapshot.docs.where((doc) =>
        doc['user1'] == currentUser.uid || doc['user2'] == currentUser.uid);

      List<Map<String, dynamic>> friends = [];
      for (var doc in friendDocs) {
        final friendId = doc['user1'] == currentUser.uid ? doc['user2'] : doc['user1'];
        final userDoc = await _firestore.collection('users').doc(friendId).get();
        final name = userDoc['name'] ?? 'Unknown';
        friends.add({'uid': friendId, 'name': name});
      }

      emit(FriendLoaded(friends));
    } catch (e) {
      emit(FriendError('Failed to load friends: $e'));
    }
  }

  Future<void> _onAddFriend(AddFriendEvent event, Emitter<FriendState> emit) async {
    final currentUser = _auth.currentUser!;
    await _firestore.collection('friends').add({
      'user1': currentUser.uid,
      'user2': event.userId,
    });
    add(LoadFriendsEvent()); // Reload after adding
  }
}
