import 'package:kaammaa/features/notiications/domain/entity/notification_entity.dart';

abstract interface class INotificationDataSource {
  Future<List<NotificationEntity>> getNotifications(String? token);

  Future<void> deleteNotification(String? token, String notificationId);
}
