import 'package:flutter/material.dart';
import 'package:kaammaa/common/app_colors.dart';
import 'package:kaammaa/view/worker/home_page_view.dart';
import 'package:kaammaa/view/worker/my_job_view.dart';
import 'package:kaammaa/view/worker/profile_page_view.dart';
import 'package:kaammaa/view/worker/search_page_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int myIndex = 0;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    String userName = "Aakash";
    String greeting = _getGreeting();
    double rating = 2.5;
    List<Widget> widgetList = [
      HomePageView(),
      SearchPageView(),
      MyJobView(),
      ProfilePageView(),
    ];

    return Scaffold(
      body: Center(child: widgetList[myIndex]),
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Material(
          elevation: 6,
          shadowColor: Colors.black26,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.only(
              top: 40,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Hi, ",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: AppColors.secondary,
                              ),
                            ),
                            TextSpan(
                              text: userName,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        greeting,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(5, (index) {
                          if (index < rating.floor()) {
                            return const Icon(
                              Icons.star,
                              size: 18,
                              color: Colors.amber,
                            );
                          } else if (index < rating && rating % 1 != 0) {
                            return const Icon(
                              Icons.star_half,
                              size: 18,
                              color: Colors.amber,
                            );
                          } else {
                            return const Icon(
                              Icons.star_border,
                              size: 18,
                              color: Colors.amber,
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: AppColors.secondary,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(size: 34),
        unselectedIconTheme: const IconThemeData(size: 28),
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "My Job"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
