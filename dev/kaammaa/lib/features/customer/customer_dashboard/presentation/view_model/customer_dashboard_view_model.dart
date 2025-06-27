import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_state.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view/customer_home_view.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view/customer_jobs_view.dart';
import 'package:kaammaa/features/customer/customer_post_jobs/presentation/view/customer_post_jobs_view.dart';
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
            CustomerJobsView(),
            CustomerPostJobsView(),
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
