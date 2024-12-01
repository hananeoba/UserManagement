import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/src/auth/presentation/cubit/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getUsers() {
    context.read<AuthCubit>().getUsers();
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        } else if (state is UserCreated) {
          getUsers();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is GettingUsers
              ? Center(child: const CircularProgressIndicator())
              : state is UsersLoaded
                  ? ListView.builder(
                      itemCount: state?.users.length,
                      itemBuilder: (context, index) {
                        final user = state.users[index];
                        return ListTile(
                          title: Text(user.name),
                          subtitle: Text(user.createdAt),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatar),
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
          floatingActionButton: FloatingActionButton.extended(
            icon: Icon(Icons.add),
            label: Text("add User"),
            onPressed: () async {
              await showDialog(
                  context: context, builder: (context) => AddUserDialog());
              context.read<AuthCubit>().createUser(
                  createdAt: DateTime.now().toString(),
                  name: "name",
                  avatar: "avatar");
            },
          ),
        );
      },
    );
  }
}
