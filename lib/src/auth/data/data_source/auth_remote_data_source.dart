import 'package:project1/src/auth/data/models/user_model.dart';

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
