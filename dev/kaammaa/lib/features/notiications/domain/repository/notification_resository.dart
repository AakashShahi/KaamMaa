import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/notiications/domain/entity/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
    String? token,
  );

  Future<Either<Failure, void>> deleteNotification(
    String? token,
    String notificationId,
  );
}
