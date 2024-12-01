import 'package:get_it/get_it.dart';
import 'package:project1/src/auth/data/data_source/auth_remote_data_source.dart';
import 'package:project1/src/auth/data/repositories/authentication_repository_implementation.dart';
import 'package:project1/src/auth/domain/repositories/authentication_repository.dart';
import 'package:project1/src/auth/domain/usecases/create_user.dart';
import 'package:project1/src/auth/domain/usecases/get_users.dart';
import 'package:project1/src/auth/presentation/cubit/auth_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;
Future<void> init() async {
  sl
    //application object
    ..registerFactory(() => AuthCubit(createUser: sl(), getUsers: sl()))
    //Use Cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    //repositories
    ..registerCachedFactory<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))

    //data sources
    ..registerCachedFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSrcImpl(sl()))

    //external dependencies
    ..registerLazySingleton(() => http.Client());
}
