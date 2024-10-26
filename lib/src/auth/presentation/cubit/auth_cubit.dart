import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project1/src/auth/domain/entities/user.dart';
import 'package:project1/src/auth/domain/usecases/create_user.dart';
import 'package:project1/src/auth/domain/usecases/get_users.dart';
import 'package:project1/src/auth/presentation/bloc/auth_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthInitial());

  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    emit(const CreatingUser());

    final result = await _createUser(CreateUserParams(
      createdAt: createdAt,
      name: name,
      avatar: avatar,
    ));
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> getUsers(GetUsersEvent event, Emitter<AuthState> emit) async {
    emit(const GettingUsers());
    final result = await _getUsers();
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
