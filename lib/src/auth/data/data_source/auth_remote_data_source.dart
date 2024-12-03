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

const kCreateUser = '/tdd/api/users';
const kGetUsers = '/tdd/api/users';

class AuthRemoteDataSrcImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSrcImpl(this._client);
  final http.Client _client;
  @override
  Future<void> createUser(
      {required String createdAt,
      required String avatar,
      required String name}) async {
    try {
      final response = await _client.post(Uri.https(kBaseUrl, kCreateUser),
          body: jsonEncode(
            {
              "createdAt": createdAt,
              "name": name,
            },
          ),
          headers: {
            'Content-Type': 'application/json',
          });
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
            message: response.body, statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<void> deleteUser() async {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client.get(Uri.https(kBaseUrl, kGetUsers));

      if (response.statusCode != 200) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
      final List<UserModel> users = (jsonDecode(response.body) as List<dynamic>)
          .map((user) => UserModel.fromMap(user))
          .toList();
      return users;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<UserModel> updateUser() {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
