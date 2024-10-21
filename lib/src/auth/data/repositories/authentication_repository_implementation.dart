import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failure.dart';
import 'package:project1/core/utils/typedef.dart';
import 'package:project1/src/auth/data/data_source/auth_remote_data_source.dart';
import 'package:project1/src/auth/domain/entities/user.dart';
import 'package:project1/src/auth/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  // dependency inversion
  // we need a data source

  @override
  ResultFuture<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    try {
      await _remoteDataSource.createUser(
          createdAt: createdAt, avatar: avatar, name: name);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultVoid deleteUser({required int id}) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    final result = await _remoteDataSource.getUsers();
    return Right(result);
  }

  @override
  ResultVoid updateUser(
      {required int id,
      required String createdAt,
      required String name,
      required String avatar}) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
