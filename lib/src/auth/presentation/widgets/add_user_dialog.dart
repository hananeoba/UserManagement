import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/src/auth/presentation/cubit/auth_cubit.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({
    super.key,
    required this.nameController,
    required this.avatarController,
  });
  final TextEditingController nameController;
  final TextEditingController avatarController;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'UserName',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    const avatar =
                        "https://cloudflare-ipfs.com/ipfs/Qmd3W5DuhgHirLHGVixi6V76LhCkZUz6pnFt5AJBiyvHye/avatar/881.jpg";
                    context.read<AuthCubit>().createUser(
                        createdAt: DateTime.now().toString(),
                        name: name,
                        avatar: avatar);
                    Navigator.of(context).pop();
                  },
                  child: const Text("create user")),
            ],
          ),
        ),
      ),
    );
  }
}
