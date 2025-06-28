import 'package:dartz/dartz.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_category/domain/repository/customer_category_repository.dart';

class GetAllCustomerCategoryUsecase
    implements UsecaseWithoutParams<List<CustomerCategoryEntity>> {
  final ICustomerCategoryRepository _customerCategoryRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  GetAllCustomerCategoryUsecase({
    required ICustomerCategoryRepository customerCategoryRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _customerCategoryRepository = customerCategoryRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, List<CustomerCategoryEntity>>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) =>
          _customerCategoryRepository.getCustomerCategories(tokenValue),
    );
  }
}
