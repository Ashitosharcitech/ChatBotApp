// 

import 'package:chat_bot_app/users_bloc/user_list.bloc.dart';
import 'package:chat_bot_app/users_bloc/user_list_event.dart';
import 'package:chat_bot_app/users_bloc/user_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserListBloc()..add(LoadUsersEvent()),
      child: Scaffold(
        appBar: AppBar(title: Text('All Users')),
        body: BlocBuilder<UserListBloc, UserListState>(
          builder: (context, state) {
            if (state is UserListLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is UserListLoaded) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return ListTile(
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                    trailing: ElevatedButton(
                      onPressed: () {
                        context
                            .read<UserListBloc>()
                            .add(SendFriendRequestEvent(user['id'], user['name']),
                            );
                      },
                      child: Text('Send Request'),
                    ),
                  );
                },
              );
            } else if (state is UserListError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No users found'));
          },
        ),
      ),
    );
  }
}
