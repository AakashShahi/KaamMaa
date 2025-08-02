import 'package:kaammaa/features/notiications/data/data_source/notification_data_source.dart';
import 'package:kaammaa/features/notiications/domain/entity/notification_entity.dart';

class GetNotificationUsecase {
  final INotificationDataSource _notificationDataSource;

  GetNotificationUsecase(this._notificationDataSource);

  Future<List<NotificationEntity>> call(String? token) {
    return _notificationDataSource.getNotifications(token);
  }
}
