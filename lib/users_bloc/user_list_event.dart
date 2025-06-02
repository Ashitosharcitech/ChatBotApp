abstract class UserListEvent {}

class LoadUsersEvent extends UserListEvent {}

class SendFriendRequestEvent extends UserListEvent {
  final String toUserId;
  final String fromName;
  SendFriendRequestEvent(this.toUserId, this.fromName);
}
