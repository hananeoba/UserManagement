import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/utils/constants.dart';
import 'package:project1/src/auth/data/data_source/auth_remote_data_source.dart';
import 'package:project1/src/auth/data/models/user_model.dart';
import 'package:project1/src/auth/data/repositories/authentication_repository_implementation.dart';
import 'package:project1/src/auth/domain/repositories/authentication_repository.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSrcImpl authRemoteDataSource;

  setUp(() {
    client = MockClient();
    authRemoteDataSource = AuthRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });

  group("create user", () {
    test("should complete successfully when called the status is 200/201 ",
        () async {
      when(() => client.post(any(), body: any(named: "body"))).thenAnswer(
          (_) async => http.Response('user created successfully ', 201));
      final methodCall = authRemoteDataSource.createUser;
      expect(methodCall(createdAt: "2024/10/15", avatar: "", name: "hanane"),
          completes);

      verify(() => client.post(Uri.parse('$kBaseUrl$kCreateUser'),
              body: jsonEncode(
                  {"createdAt": "2024/10/15", "avatar": "", "name": "hanane"})))
          .called(1);
      verifyNoMoreInteractions(client);
    });
    test("should throw api exception when status code is not  201 or 200",
        () async {
      when(() => client.post(any(), body: any(named: "body")))
          .thenAnswer((_) async => http.Response(
                'invalid email address',
                400,
              ));
      final methodCall = authRemoteDataSource.createUser;
      expect(
          () async =>
              methodCall(createdAt: "2024/10/15", avatar: "", name: "hanane"),
          throwsA(const ApiException(
            message: "invalid email address",
            statusCode: 400,
          )));

      verify(() => client.post(
            Uri.parse('${kBaseUrl}${kCreateUser}'),
            body: jsonEncode(
              {"createdAt": "2024/10/15", "avatar": "", "name": "hanane"},
            ),
          )).called(1);
      verifyNoMoreInteractions(client);
    });
  });
  group("get users", () {
    const List<UserModel> tUsers = [UserModel.empty()];
    test(
        "should return list of users successfully when called the status is 200/201 ",
        () async {
      when(() => client.get(any()))
          .thenAnswer((_) async => http.Response(jsonEncode(tUsers), 200));
      final result = await authRemoteDataSource.getUsers();
      expect(result, equals(tUsers));

      verify(() => client.get(
            Uri.https(
              kBaseUrl,
              kGetUsers,
            ),
          )).called(1);
      verifyNoMoreInteractions(client);
    });
    test("should throw api exception when status code is not  201 or 200",
        () async {
      when(() => client.get(
            any(),
          )).thenAnswer((_) async => http.Response(
            'invalid email address',
            400,
          ));
      final methodCall = authRemoteDataSource.getUsers;
      expect(
          () async => methodCall(),
          throwsA(const ApiException(
            message: "invalid email address",
            statusCode: 400,
          )));

      verify(() => client.get(
            Uri.https(kBaseUrl, kCreateUser),
          )).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
