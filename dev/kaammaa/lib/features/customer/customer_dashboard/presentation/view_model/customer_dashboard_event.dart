abstract class CustomerDashboardEvent {}

class ChangeCustomerTabEvent extends CustomerDashboardEvent {
  final int newIndex;
  ChangeCustomerTabEvent({required this.newIndex});
}
