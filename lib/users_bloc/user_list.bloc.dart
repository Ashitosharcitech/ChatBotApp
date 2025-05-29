import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserListBloc() : super(UserListInitial()) {
    on<LoadUsersEvent>(_onLoadUsers);
    on<SendFriendRequestEvent>(_onSendFriendRequest);
  }

  Future<void> _onLoadUsers(LoadUsersEvent event, Emitter<UserListState> emit) async {
    emit(UserListLoading());

    try {
      final snapshot = await _firestore.collection('users').get();
      final currentUser = _auth.currentUser;
      final users = snapshot.docs
          .where((doc) => doc.id != currentUser?.uid)
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'] ?? 'Unknown',
                'email': doc['email'],
              })
          .toList();

      emit(UserListLoaded(users));
    } catch (e) {
      emit(UserListError('Failed to load users: $e'));
    }
  }

  Future<void> _onSendFriendRequest(
      SendFriendRequestEvent event, Emitter<UserListState> emit) async {
    final currentUser = _auth.currentUser;
    try {
      final existing = await _firestore
          .collection('friend_requests')
          .where('from', isEqualTo: currentUser!.uid)
          .where('to', isEqualTo: event.toUserId)
          .get();

      if (existing.docs.isEmpty) {
        await _firestore.collection('friend_requests').add({
          'from': currentUser.uid,
          'fromName': event.fromName, 
          'to': event.toUserId,
          'status': 'pending',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      emit(UserListError('Failed to send request: $e'));
    }
  }
}
