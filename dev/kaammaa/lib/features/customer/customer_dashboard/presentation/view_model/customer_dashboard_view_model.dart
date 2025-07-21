import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/features/auth/domain/use_case/get_current_user_usecase.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_event.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_view_model.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_state.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view/customer_home_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_post_jobs_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_inprogress_viewmodel/customer_inprogress_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_requested_jobs_viewmodel/customer_requested_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/customer_profile_view.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view/customer_reviews_view.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view_model/customer_get_reviews_viewmodel/customer_get_reviews_viewmodel.dart';

class CustomerDashboardViewModel
    extends Bloc<CustomerDashboardEvent, CustomerDashboardState> {
  final GetCurrentUserUsecase _getCurrentUserUsecase =
      serviceLocater<GetCurrentUserUsecase>();

  CustomerDashboardViewModel()
    : super(
        CustomerDashboardState(
          selectedIndex: 0,
          widgetList: [
            BlocProvider.value(
              value:
                  serviceLocater<CustomerHomeViewModel>()
                    ..add(LoadCustomerHomeData()),
              child: CustomerHomeView(),
            ),
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value:
                      serviceLocater<CustomerPostedJobsViewModel>()
                        ..add(LoadCustomerPostedJobs()),
                ),
                BlocProvider.value(
                  value:
                      serviceLocater<CustomerAssignedJobsViewModel>()
                        ..add(LoadCustomerAssignedJobs()),
                ),
                BlocProvider.value(
                  value:
                      serviceLocater<CustomerRequestedJobsViewModel>()
                        ..add(LoadCustomerRequestedJobs()),
                ),
                BlocProvider.value(
                  value:
                      serviceLocater<CustomerInProgressJobsViewModel>()
                        ..add(LoadCustomerInProgressJobs()),
                ),
              ],
              child: const CustomerJobsView(),
            ),
            BlocProvider.value(
              value: serviceLocater<CustomerPostJobsViewModel>(),
              child: CustomerPostJobsView(),
            ),
            BlocProvider.value(
              value: serviceLocater<CustomerGetReviewsViewModel>(),
              child: CustomerReviewsView(),
            ),
            BlocProvider.value(
              value: serviceLocater<CustomerProfileViewModel>(),
              child: CustomerProfileView(),
            ),
          ],
        ),
      ) {
    on<ChangeCustomerTabEvent>(_onChangeTab);
    on<LoadCustomerUserEvent>(_onLoadCustomerUser);

    // Load user when initialized
    add(LoadCustomerUserEvent());
  }

  void _onChangeTab(
    ChangeCustomerTabEvent event,
    Emitter<CustomerDashboardState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.newIndex));
  }

  Future<void> _onLoadCustomerUser(
    LoadCustomerUserEvent event,
    Emitter<CustomerDashboardState> emit,
  ) async {
    final result = await _getCurrentUserUsecase.call();
    result.fold(
      (failure) {
        // Handle error if needed
      },
      (user) {
        emit(
          state.copyWith(
            userName: user.name ?? 'Customer',
            userPhoto: user.profilePic,
          ),
        );
      },
    );
  }
}
