import 'package:kaammaa/features/notiications/data/data_source/notification_data_source.dart';

class DeleteNotificationUsecase {
  final INotificationDataSource _notificationDataSource;

  DeleteNotificationUsecase(this._notificationDataSource);

  Future<void> call(String? token, String notificationId) async {
    await _notificationDataSource.deleteNotification(token, notificationId);
  }
}
