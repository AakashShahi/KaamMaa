import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/worker/my_job/presentation/view/my_job_view.dart';
import 'package:kaammaa/features/worker/search_job/presentation/view/search_page_view.dart';
import 'package:kaammaa/features/worker/woker_profile/presentation/view/profile_page_view.dart';
import 'package:kaammaa/features/worker/worker_dashboard/presentation/view/home_page_view.dart';
import 'package:kaammaa/features/worker/worker_dashboard/presentation/view_model/worker_dashboard_event.dart';
import 'package:kaammaa/features/worker/worker_dashboard/presentation/view_model/worker_dashboard_state.dart';

class WorkerDashboardViewModel
    extends Bloc<WorkerDashboardEvent, WorkerDashboardState> {
  WorkerDashboardViewModel()
    : super(
        WorkerDashboardState(
          selectedIndex: 0,
          widgetList: const [
            HomePageView(),
            SearchPageView(),
            MyJobView(),
            ProfilePageView(),
          ],
        ),
      ) {
    on<ChangeTabEvent>((event, emit) {
      emit(state.copyWith(selectedIndex: event.newIndex));
    });
  }
}
