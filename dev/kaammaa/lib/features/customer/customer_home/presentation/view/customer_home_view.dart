import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_event.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_state.dart';
import 'package:kaammaa/features/customer/customer_home/presentation/view_model/customer_home_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_jobs/domain/entity/customer_jobs_entity.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomerHomeView extends StatefulWidget {
  const CustomerHomeView({super.key});

  @override
  State<CustomerHomeView> createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  List<DateTime> _markedDates(List<CustomerJobsEntity> jobs) {
    return jobs.map((job) {
      try {
        return DateTime.parse(job.date);
      } catch (_) {
        return DateTime.now();
      }
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    context.read<CustomerHomeViewModel>().add(LoadCustomerHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerHomeViewModel, CustomerHomeState>(
      builder: (context, state) {
        if (state is CustomerHomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerHomeError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: AppColors.primary),
            ),
          );
        } else if (state is CustomerHomeLoaded) {
          final postedCount = state.postedJobsCount;
          final inProgressJobs = state.inProgressJobs;
          final markedDates = _markedDates(inProgressJobs);

          return Scaffold(
            backgroundColor: AppColors.background,
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<CustomerHomeViewModel>().add(
                  LoadCustomerHomeData(),
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 8),
                      child: Text(
                        "Your Job Stats",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),

                    // Info Cards Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _infoCard(
                            title: "Posted Jobs",
                            count: postedCount,
                            color: Colors.blue,
                            icon: Icons.post_add,
                          ),
                          _infoCard(
                            title: "In-Progress Jobs",
                            count: inProgressJobs.length,
                            color: Colors.deepOrange,
                            icon: Icons.work,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Calendar Title + Format Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Job Schedule",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        DropdownButton<CalendarFormat>(
                          value: _calendarFormat,
                          borderRadius: BorderRadius.circular(8),
                          onChanged: (format) {
                            if (format != null) {
                              setState(() => _calendarFormat = format);
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: CalendarFormat.month,
                              child: Text("Month"),
                            ),
                            DropdownMenuItem(
                              value: CalendarFormat.twoWeeks,
                              child: Text("2 Weeks"),
                            ),
                            DropdownMenuItem(
                              value: CalendarFormat.week,
                              child: Text("Week"),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Calendar
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate:
                          (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      headerVisible: false,
                      calendarStyle: CalendarStyle(
                        defaultDecoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          shape: BoxShape.circle,
                        ),
                      ),
                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekendStyle: TextStyle(color: Colors.red),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, _) {
                          final isMarked = markedDates.any(
                            (d) => isSameDay(d, day),
                          );
                          if (isMarked) {
                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // In Progress Jobs Title + View All
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "In Progress Jobs",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<CustomerDashboardViewModel>().add(
                              ChangeCustomerTabEvent(newIndex: 1),
                            );
                          },
                          child: Text(
                            "View All",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Job List or Placeholder
                    if (inProgressJobs.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Image.asset(
                              "assets/logo/kaammaa_txt.png",
                              height: 20,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "No In-Progress Jobs Found",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "You have no in progress jobs yet.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...inProgressJobs.take(2).map((job) => _jobListTile(job)),
                  ],
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _infoCard({
    required String title,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white,
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jobListTile(CustomerJobsEntity job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.work, color: AppColors.primary),
        title: Text(
          job.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Date: ${job.date}, Location: ${job.location}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          // Optional: Show detailed bottom sheet
        },
      ),
    );
  }
}
