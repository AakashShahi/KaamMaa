import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_event.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_state.dart';
import 'package:kaammaa/features/customer/customer_jobs/presentation/view_model/customer_post_job_view_model/customer_post_job_viewmodel.dart';

class CustomerPostJobsView extends StatefulWidget {
  const CustomerPostJobsView({super.key});

  @override
  State<CustomerPostJobsView> createState() => _CustomerPostJobsViewState();
}

class _CustomerPostJobsViewState extends State<CustomerPostJobsView> {
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  CustomerCategoryEntity? selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CustomerPostJobsViewModel>().add(LoadCategories());
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

  void _submitJob() {
    if (descriptionController.text.isEmpty ||
        locationController.text.isEmpty ||
        selectedCategory == null ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final date = DateFormat('yyyy-MM-dd').format(selectedDate!);
    final time = selectedTime!.format(context);

    context.read<CustomerPostJobsViewModel>().add(
      PostJobRequested(
        description: descriptionController.text.trim(),
        location: locationController.text.trim(),
        category: selectedCategory!,
        date: date,
        time: time,
        context: context,
        onSuccess: () {
          context.read<CustomerDashboardViewModel>().add(
            ChangeCustomerTabEvent(newIndex: 1),
          );
        },
      ),
    );
    descriptionController.clear();
    locationController.clear();
    setState(() {
      selectedCategory = null;
      selectedDate = null;
      selectedTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<CustomerPostJobsViewModel, CustomerPostJobsState>(
        builder: (context, state) {
          List<CustomerCategoryEntity> categories = [];
          bool isLoadingCategories = false;
          bool isPosting = false;

          if (state is CategoriesLoading) {
            isLoadingCategories = true;
          } else if (state is CategoriesLoaded) {
            categories = state.categories;
          } else if (state is CustomerPostJobsLoading) {
            isPosting = true;
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Post a Job",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabel("Job Description"),
                _buildInputCard(
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: _inputDecoration("Enter job details"),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel("Location"),
                _buildInputCard(
                  TextField(
                    controller: locationController,
                    decoration: _inputDecoration("Enter job location"),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel("Category"),
                _buildInputCard(
                  isLoadingCategories
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<CustomerCategoryEntity>(
                        decoration: _inputDecoration("Choose category"),
                        value: selectedCategory,
                        isExpanded: true,
                        items:
                            categories
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.category ?? 'Unknown'),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) => setState(() => selectedCategory = value),
                      ),
                ),
                const SizedBox(height: 16),
                _buildLabel("Date"),
                _buildInputCard(
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : "Pick a date",
                    ),
                    onTap: _pickDate,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLabel("Time"),
                _buildInputCard(
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.access_time),
                    title: Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : "Pick a time",
                    ),
                    onTap: _pickTime,
                  ),
                ),
                const SizedBox(height: 28),
                Center(
                  child:
                      isPosting
                          ? const CircularProgressIndicator()
                          : ElevatedButton.icon(
                            onPressed: _submitJob,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text("Submit Job"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.secondary,
                              minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInputCard(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        // <-- Removed border here to fix double border issue
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: InputBorder.none,
      isDense: true,
    );
  }
}
