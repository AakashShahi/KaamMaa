import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kaammaa/core/network/api_service.dart';
import 'package:kaammaa/core/network/hive_service.dart';
import 'package:kaammaa/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:kaammaa/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
import 'package:kaammaa/features/auth/data/repository/local_repository/auth_local_repository.dart';
import 'package:kaammaa/features/auth/data/repository/remote_repository/auth_remote_repository.dart';
import 'package:kaammaa/features/auth/domain/use_case/auth_login_usecase.dart';
import 'package:kaammaa/features/auth/domain/use_case/auth_register_usecase.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';
import 'package:kaammaa/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocater = GetIt.instance;

Future initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSplashModule();
  await _initOnBoardingModule();
  await _initSelectionModule();
  await _initAuthModule();
}

Future<void> _initApiService() async {
  serviceLocater.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initHiveService() async {
  serviceLocater.registerLazySingleton(() => HiveService());
}

Future _initSplashModule() async {
  serviceLocater.registerFactory(() => SplashViewModel());
}

Future _initOnBoardingModule() async {
  serviceLocater.registerFactory(() => OnboardingViewModel());
}

Future _initSelectionModule() async {
  serviceLocater.registerLazySingleton(() => SelectionViewModel());
}

Future _initAuthModule() async {
  serviceLocater.registerFactory(
    () => AuthLocalDataSource(hiveService: serviceLocater<HiveService>()),
  );

  serviceLocater.registerFactory(
    () => AuthRemoteDatasource(apiservice: serviceLocater<ApiService>()),
  );

  serviceLocater.registerFactory(
    () => AuthLocalRepository(
      authLocalDatasource: serviceLocater<AuthLocalDataSource>(),
    ),
  );

  serviceLocater.registerFactory(
    () => AuthRemoteRepository(
      authRemoteDataSource: serviceLocater<AuthRemoteDatasource>(),
    ),
  );

  serviceLocater.registerFactory(
    () => AuthLoginUsecase(
      authRepository: serviceLocater<AuthRemoteRepository>(),
    ),
  );

  serviceLocater.registerFactory(
    () => AuthRegisterUsecase(
      authRepository: serviceLocater<AuthRemoteRepository>(),
    ),
  );

  serviceLocater.registerLazySingleton(
    () => SignupViewModel(serviceLocater<AuthRegisterUsecase>()),
  );

  serviceLocater.registerLazySingleton(
    () => LoginViewModel(serviceLocater<AuthLoginUsecase>()),
  );
}
