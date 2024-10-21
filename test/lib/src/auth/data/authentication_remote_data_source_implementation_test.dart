import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:project1/core/utils/constants.dart';
import 'package:project1/src/auth/data/data_source/auth_remote_data_source.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthRemoteDataSource authRemoteDataSource;

  setUp(() {
    client = MockClient();
    authRemoteDataSource = AuthRemoteDataSrcImpl(client);
    registerFallbackValue(Uri());
  });

  group("create user", () {
    test("should complete successfully when called the status is 200/201 ",
        () async {
      when(() => client.post(any(), body: any(named: ""))).thenAnswer(
          (_) async => http.Response('user creqteed successfully ', 201));
      final methodCall = authRemoteDataSource.createUser;
      expect(methodCall(createdAt: "2024/10/15", avatar: "", name: "hanane"),
          completes);

      verify(() => client.post(Uri.parse('$kBaseUrl$kCreateUser'),
              body: jsonEncode(
                  {"createdAt": "2024/10/15", "avatar": "", "name": "hanane"})))
          .called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
