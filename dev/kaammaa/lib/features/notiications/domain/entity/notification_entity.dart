import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? id;
  final String? title;
  final String? body;
  final bool? seen;

  const NotificationEntity({
    required this.id,
    this.title,
    this.body,
    this.seen,
  });

  @override
  List<Object?> get props => [id, title, body, seen];
}
