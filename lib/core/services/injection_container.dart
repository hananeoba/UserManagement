import 'package:get_it/get_it.dart';
import 'package:project1/src/auth/data/repositories/authentication_repository_implementation.dart';
import 'package:project1/src/auth/domain/repositories/authentication_repository.dart';
import 'package:project1/src/auth/domain/usecases/create_user.dart';
import 'package:project1/src/auth/domain/usecases/get_users.dart';
import 'package:project1/src/auth/presentation/cubit/auth_cubit.dart';

final sl = GetIt.instance;
Future<void> init() async {
  sl
    ..registerFactory(() => AuthCubit(createUser: sl(), getUsers: sl()))
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    ..registerCachedFactory<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()));
}
