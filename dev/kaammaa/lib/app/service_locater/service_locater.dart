import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
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
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';
import 'package:kaammaa/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:kaammaa/features/worker/worker_dashboard/presentation/view_model/worker_dashboard_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocater = GetIt.instance;

Future initDependencies() async {
  await _initHiveService();
  await _initApiService();
  await _initSharedPreferences();
  await _initSplashModule();
  await _initOnBoardingModule();
  await _initSelectionModule();
  await _initAuthModule();

  //Worker Dashboard Module
  await _initWorkerDashboardModule();

  //Customer Dashboard Module
  await _initCustomerDashboardModule();
}

Future<void> _initApiService() async {
  serviceLocater.registerLazySingleton(() => ApiService(Dio()));
}

Future<void> _initHiveService() async {
  serviceLocater.registerLazySingleton(() => HiveService());
}

Future<void> _initSharedPreferences() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocater.registerLazySingleton(() => sharedPrefs);
  serviceLocater.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocater<SharedPreferences>(),
    ),
  );
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
    () => AuthRemoteDatasource(
      apiservice: serviceLocater<ApiService>(),
      tokenSharedPrefs: serviceLocater<TokenSharedPrefs>(),
    ),
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
      tokenSharedPrefs: serviceLocater<TokenSharedPrefs>(),
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
    () => LoginViewModel(
      serviceLocater<AuthLoginUsecase>(),
      serviceLocater<TokenSharedPrefs>(),
    ),
  );
}

//Worker Dashboard Module
Future<void> _initWorkerDashboardModule() async {
  serviceLocater.registerLazySingleton(() => WorkerDashboardViewModel());
}

//Customer Dashboard Module
Future<void> _initCustomerDashboardModule() async {
  serviceLocater.registerLazySingleton(() => CustomerDashboardViewModel());
}
