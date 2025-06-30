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
import 'package:kaammaa/features/customer/customer_category/data/data_source/remote_data_source/customer_category_remote_datasource.dart';
import 'package:kaammaa/features/customer/customer_category/data/repository/remote_repository/customer_category_remote_repository.dart';
import 'package:kaammaa/features/customer/customer_category/domain/use_case/get_all_customer_category_usecase.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/data/data_source/remote_data_source.dart/customer_jobs_remote_datasource.dart';
import 'package:kaammaa/features/customer/customer_jobs/data/repository/remote_respository/customer_jobs_remote_repository.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/assign_worker_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/delete_posted_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/get_all_public_jobs_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/use_case/post_public_job_usecase.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/worker_list_viewmodel/worker_list_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_workers/data/data_source/remote_datasource/customer_worker_remote_datasource.dart';
import 'package:kaammaa/features/customer/customer_workers/data/repository/remote_repository/customer_worker_remote_repository.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/use_case/get_matching_worker_usecase.dart';
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
  await _initCustomerJobsModule();
  await _initCustomerCategoryModule();
}

// ________________________________________________________________
Future<void> _initApiService() async {
  serviceLocater.registerLazySingleton(() => ApiService(Dio()));
}

// ________________________________________________________________
Future<void> _initHiveService() async {
  serviceLocater.registerLazySingleton(() => HiveService());
}

// ________________________________________________________________
Future<void> _initSharedPreferences() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocater.registerLazySingleton(() => sharedPrefs);
  serviceLocater.registerLazySingleton(
    () => TokenSharedPrefs(
      sharedPreferences: serviceLocater<SharedPreferences>(),
    ),
  );
}

// ________________________________________________________________
Future _initSplashModule() async {
  serviceLocater.registerFactory(() => SplashViewModel());
}

// ________________________________________________________________
Future _initOnBoardingModule() async {
  serviceLocater.registerFactory(() => OnboardingViewModel());
}

// ________________________________________________________________
Future _initSelectionModule() async {
  serviceLocater.registerLazySingleton(() => SelectionViewModel());
}

// ________________________________________________________________
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
// ________________________________________________________________
Future<void> _initWorkerDashboardModule() async {
  serviceLocater.registerLazySingleton(() => WorkerDashboardViewModel());
}

//Customer Dashboard Module
// ________________________________________________________________
Future<void> _initCustomerDashboardModule() async {
  serviceLocater.registerLazySingleton(() => CustomerDashboardViewModel());
}

// ________________________________________________________________
Future<void> _initCustomerJobsModule() async {
  // Registering the CustomerJobsRemoteDatasource, Repository, and Usecase
  serviceLocater.registerFactory(
    () =>
        CustomerJobsRemoteDatasource(apiService: serviceLocater<ApiService>()),
  );

  serviceLocater.registerFactory(
    () => CustomerWorkerRemoteDatasource(
      apiService: serviceLocater<ApiService>(),
    ),
  );

  serviceLocater.registerFactory(
    () => CustomerJobsRemoteRepository(
      remoteDatasource: serviceLocater<CustomerJobsRemoteDatasource>(),
    ),
  );
  serviceLocater.registerFactory(
    () => CustomerWorkerRemoteRepository(
      remoteDatasource: serviceLocater<CustomerWorkerRemoteDatasource>(),
    ),
  );

  serviceLocater.registerFactory(
    () => GetAllPublicJobsUsecase(
      customerJobsRepository: serviceLocater<CustomerJobsRemoteRepository>(),
      tokenSharedPrefs: serviceLocater<TokenSharedPrefs>(),
    ),
  );
  serviceLocater.registerFactory(
    () => GetMatchingWorkerUsecase(
      customerWorkerRepository:
          serviceLocater<CustomerWorkerRemoteRepository>(),
      tokenSharedPrefs: serviceLocater<TokenSharedPrefs>(),
    ),
  );

  serviceLocater.registerFactory(
    () => AssignWorkerUsecase(
      customerJobsRepository: serviceLocater<CustomerJobsRemoteRepository>(),
      tokenSharedPrefs: serviceLocater<TokenSharedPrefs>(),
    ),
  );

  serviceLocater.registerFactory(
    () => DeletePostedJobUsecase(
      customerJobsRepository: serviceLocater<CustomerJobsRemoteRepository>(),
      tokenSharedPrefs: serviceLocater<TokenSharedPrefs>(),
    ),
  );

  serviceLocater.registerFactory(
    () => CustomerPostedJobsViewModel(
      serviceLocater<GetAllPublicJobsUsecase>(),
      serviceLocater<DeletePostedJobUsecase>(),
    ),
  );

  serviceLocater.registerFactory(
    () => CustomerWorkerListViewModel(
      getMatchingWorkerUsecase: serviceLocater<GetMatchingWorkerUsecase>(),
      assignWorkerUsecase: serviceLocater<AssignWorkerUsecase>(),
    ),
  );

  serviceLocater.registerFactory(
    () => PostPublicJobUsecase(
      customerJobsRepository: serviceLocater<CustomerJobsRemoteRepository>(),
      tokenSharedPrefs: serviceLocater<TokenSharedPrefs>(),
    ),
  );

  serviceLocater.registerFactory(
    () => CustomerPostJobsViewModel(
      postPublicJobUsecase: serviceLocater<PostPublicJobUsecase>(),
      getCategoriesUsecase: serviceLocater<GetAllCustomerCategoryUsecase>(),
    ),
  );
}

// ________________________________________________________________
Future<void> _initCustomerCategoryModule() async {
  serviceLocater.registerFactory(
    () => CustomerCategoryRemoteDatasource(
      apiService: serviceLocater<ApiService>(),
    ),
  );

  serviceLocater.registerFactory(
    () => CustomerCategoryRemoteRepository(
      customerCategoryRemoteDatasource:
          serviceLocater<CustomerCategoryRemoteDatasource>(),
    ),
  );

  serviceLocater.registerFactory(
    () => GetAllCustomerCategoryUsecase(
      customerCategoryRepository:
          serviceLocater<CustomerCategoryRemoteRepository>(),
      tokenSharedPrefs: serviceLocater<TokenSharedPrefs>(),
    ),
  );
}
