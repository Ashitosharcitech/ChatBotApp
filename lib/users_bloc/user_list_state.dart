abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<Map<String, dynamic>> users;
  UserListLoaded(this.users);
}

class UserListError extends UserListState {
  final String message;
  UserListError(this.message);
}
