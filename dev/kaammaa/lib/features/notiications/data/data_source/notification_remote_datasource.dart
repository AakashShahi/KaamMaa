import 'package:kaammaa/features/notiications/data/data_source/notification_data_source.dart';
import 'package:kaammaa/features/notiications/domain/entity/notification_entity.dart';

class NotificationRemoteDatasource implements INotificationDataSource {
  @override
  Future<void> deleteNotification(String? token, String notificationId) {
    try {
      // Implement the logic to delete a notification using the provided token and notificationId
      // This could involve making an HTTP DELETE request to an API endpoint
      throw UnimplementedError();
    } catch (e) {
      // Handle any exceptions that may occur during the deletion process
      throw Exception('Failed to delete notification: $e');
    }
  }

  @override
  Future<List<NotificationEntity>> getNotifications(String? token) {
    try {
      // Implement the logic to fetch notifications using the provided token
      // This could involve making an HTTP GET request to an API endpoint
      throw UnimplementedError();
    } catch (e) {
      // Handle any exceptions that may occur during the fetching process
      throw Exception('Failed to fetch notifications: $e');
    }
  }
}
