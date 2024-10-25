import 'dart:convert';

import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/utils/constants.dart';
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
    final response = await _client.post(Uri.parse("$kBaseUrl$kCreateUser"),
        body: jsonEncode(
          {
            "createdAt": createdAt,
            "avatar": avatar,
            "name": name,
          },
        ));
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ApiException(
          message: response.body, statusCode: response.statusCode);
    }
  }

  @override
  Future<void> deleteUser() async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final Users = await _client.get(Uri.parse("$kBaseUrl$kCreateUser"))
        as List<UserModel>;
    return Users;
  }

  @override
  Future<UserModel> updateUser() async {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
