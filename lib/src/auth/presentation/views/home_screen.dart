import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/src/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/src/auth/presentation/widgets/add_user_dialog.dart';
import 'package:project1/src/auth/presentation/widgets/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController avatarController = TextEditingController();

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
              ? const LoadingColumn(message: "Getting users...")
              : state is CreatingUser
                  ? const LoadingColumn(message: "Creating User")
                  : state is UsersLoaded
                      ? Center(
                          child: ListView.builder(
                          itemCount: state.users.length,
                          itemBuilder: (context, index) {
                            final user = state.users[index];
                            return Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                leading: Image.network(user.avatar),
                                title: Text(user.name),
                                subtitle: Text(user.createdAt.substring(10)),
                              ),
                            );
                          },
                        ))
                      : const SizedBox.shrink(),
          floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text("add User"),
            onPressed: () async {
              await showDialog(
                  context: context,
                  builder: (context) => AddUserDialog(
                        avatarController: nameController,
                        nameController: avatarController,
                      ));
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
