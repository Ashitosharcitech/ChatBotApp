abstract class FriendState {}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendLoaded extends FriendState {
  final List<Map<String, dynamic>> friends;
  FriendLoaded(this.friends);
}

class FriendError extends FriendState {
  final String message;
  FriendError(this.message);
}
