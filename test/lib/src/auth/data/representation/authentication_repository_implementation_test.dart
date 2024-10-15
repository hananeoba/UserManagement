import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/errors/failure.dart';
import 'package:project1/src/auth/data/data_source/auth_remote_data_source.dart';
import 'package:project1/src/auth/data/repositories/authentication_repository_implementation.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthRemoteDataSource {}

main() {
  //dependency : Mock of auth remote source
  // initiate the class to be tested
  late AuthenticationRepositoryImplementation repoImpl;
  late AuthRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });
  //group to test the calling of the dependency

  group('createUser', () {
    const createdAt = '2024/10/15';
    const name = 'hanane';
    const avatar = '';

    const tException = ApiException(message: 'unkwonn', statusCode: 500);
    test(
        "should call remote data source .create use and complete successfully ",
        () async {
      //arange

      //manipulate dependency
      when(
        () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
            name: any(named: 'name')),
      ).thenAnswer((_) async => Future.value());
      //act
      //initiate your actual result

      final result = await repoImpl.createUser(
          avatar: avatar, name: name, createdAt: createdAt); //what is here
      //assert
      //compare between expected and actual results

      expect(result, equals(const Right(null)));
      verify(() => remoteDataSource.createUser(
          createdAt: createdAt,
          avatar: avatar,
          name: name)).called(1); //shouold be in here

      verifyNoMoreInteractions(remoteDataSource);
    });
    test('server failure when remote cqll is unsuccessful', () async {
      //stub
      when(
        () => remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            avatar: any(named: 'avatar'),
            name: any(named: 'name')),
      ).thenThrow(tException);

      //act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      // assert

      expect(result, equals(Left(ApiFailure.fromApiException(tException))));
      verify(() => remoteDataSource.createUser(
          createdAt: createdAt,
          avatar: avatar,
          name: name)).called(1); //shouold be in here
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
