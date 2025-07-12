import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}
