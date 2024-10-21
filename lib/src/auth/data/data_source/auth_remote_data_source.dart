import 'dart:convert';

import 'package:project1/src/auth/data/models/user_model.dart';
import "package:http/http.dart" as http;

abstract class AuthRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String avatar,
    required String name,
  });

  Future<List<UserModel>> getUsers();
  Future<UserModel> updateUser();
  Future<void> deleteUser();
}

const kCreateUser = '/users';
const kGetUsers = '/users';

class AuthRemoteDataSrcImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSrcImpl(this._client);
  final http.Client _client;
  @override
  Future<void> createUser(
      {required String createdAt,
      required String avatar,
      required String name}) async {
    final response = await _client.post(Uri.parse("$kGetUsers$kCreateUser"),
        body: jsonEncode(
          {
            "createdAt": createdAt,
            "avatar": avatar,
            "name": name,
          },
        ));
  }

  @override
  Future<void> deleteUser() async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUsers() async {
    // TODO: implement getUsers
    throw UnimplementedError();
  }

  @override
  Future<UserModel> updateUser() async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
