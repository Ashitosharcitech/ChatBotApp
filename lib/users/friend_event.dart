abstract class FriendEvent {}

class LoadFriendsEvent extends FriendEvent {}

class AddFriendEvent extends FriendEvent {
  final String userId;
  final String name;
  AddFriendEvent(this.userId, this.name);
}
