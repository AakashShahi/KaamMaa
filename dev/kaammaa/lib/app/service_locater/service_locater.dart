import 'package:get_it/get_it.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';
import 'package:kaammaa/features/splash/presentation/view_model/splash_view_model.dart';

final serviceLocater = GetIt.instance;

Future initDependencies() async {
  await _initSplashModule();
  await _initOnBoardingModule();
  await _initSelectionModule();
}

Future _initSplashModule() async {
  serviceLocater.registerFactory(() => SplashViewModel());
}

Future _initOnBoardingModule() async {
  serviceLocater.registerFactory(() => OnboardingViewModel());
}

Future _initSelectionModule() async {
  serviceLocater.registerFactory(() => SelectionViewModel());
}
