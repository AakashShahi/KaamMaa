import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_state.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';

class CustomerDashboardView extends StatelessWidget {
  const CustomerDashboardView({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();

    return BlocBuilder<CustomerDashboardViewModel, CustomerDashboardState>(
      builder: (context, state) {
        final userName = state.userName ?? "Customer";
        final userPhoto = state.userPhoto;

        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Material(
              elevation: 8,
              shadowColor: Colors.black38,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 60,
                  left: 24,
                  right: 24,
                  bottom: 20,
                ),
                color: AppColors.primary,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 27,
                        backgroundImage:
                            userPhoto != null
                                ? NetworkImage(getBackendImageUrl(userPhoto))
                                : const AssetImage(
                                      'assets/images/default_profile.png',
                                    )
                                    as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello, $userName",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            greeting,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 10,
                          top: 8,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: state.widgetList[state.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) {
              context.read<CustomerDashboardViewModel>().add(
                ChangeCustomerTabEvent(newIndex: index),
              );
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 12,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey.shade600,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              letterSpacing: 0.25,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              letterSpacing: 0.15,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_outline),
                activeIcon: Icon(Icons.work_rounded),
                label: "Jobs",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle, size: 34),
                label: "Create Job",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.rate_review_outlined),
                activeIcon: Icon(Icons.rate_review_rounded),
                label: "Reviews",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person_rounded),
                label: "Profile",
              ),
            ],
          ),
        );
      },
    );
  }
}
