import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project1/core/errors/failure.dart';
import 'package:project1/src/auth/domain/usecases/create_user.dart';
import 'package:project1/src/auth/domain/usecases/get_users.dart';
import 'package:project1/src/auth/presentation/cubit/auth_cubit.dart';
import 'package:bloc_test/bloc_test.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthCubit cubit;

  const CreateUserParams tcreateUserParams = CreateUserParams.empty();
  const tApiFailure = ApiFailure(message: 'error', statusCode: 500);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tcreateUserParams);
  });

  tearDown(() => cubit.close());

  test("initial state should be authinitial ", () async {
    expect(cubit.state, const AuthInitial());
  });
  group("createUser", () {
    blocTest<AuthCubit, AuthState>(
      'emits [creatinguser, userCreated] when successful',
      build: () {
        when(() => createUser(any())).thenAnswer((_) async => Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tcreateUserParams.createdAt,
        name: tcreateUserParams.name,
        avatar: tcreateUserParams.avatar,
      ),
      expect: () => const [
        CreatingUser(),
        UserCreated(),
      ],
      verify: (_) {
        verify(() => createUser(tcreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
    blocTest<AuthCubit, AuthState>(
      'emits [authError] when successful',
      build: () {
        when(() => createUser(any())).thenAnswer(
          (_) async => const Left(tApiFailure),
        );
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tcreateUserParams.createdAt,
        name: tcreateUserParams.name,
        avatar: tcreateUserParams.avatar,
      ),
      expect: () => [
        const CreatingUser(),
        AuthError(tApiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUser(tcreateUserParams)).called(1);
        verifyNoMoreInteractions(createUser);
      },
    );
  });
}
