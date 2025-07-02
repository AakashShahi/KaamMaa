import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_assigned_job_view_model/customer_assigned_job_view_model.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_state.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view/customer_home_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_post_jobs_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_jobs_view_model/customer_posted_jobs_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/customer_profile_view.dart';
import 'package:kaammaa/features/customer/customer_reviews/presentation/view/customer_reviews_view.dart';

class CustomerDashboardViewModel
    extends Bloc<CustomerDashboardEvent, CustomerDashboardState> {
  CustomerDashboardViewModel()
    : super(
        CustomerDashboardState(
          selectedIndex: 0,
          widgetList: [
            CustomerHomeView(),
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
              ],
              child: const CustomerJobsView(),
            ),
            BlocProvider.value(
              value: serviceLocater<CustomerPostJobsViewModel>(),
              child: CustomerPostJobsView(),
            ),
            CustomerReviewsView(),
            CustomerProfileView(),
          ],
        ),
      ) {
    on<ChangeCustomerTabEvent>(_onChangeTab);
  }

  void _onChangeTab(
    ChangeCustomerTabEvent event,
    Emitter<CustomerDashboardState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.newIndex));
  }
}
