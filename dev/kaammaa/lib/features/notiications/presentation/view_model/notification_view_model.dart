import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationViewModel implements Cubit {
  @override
  void emit(state) {
    // Implementation of emit method
  }

  @override
  void onChange(Change change) {
    // Implementation of onChange method
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Implementation of onError method
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    // TODO: implement addError
  }

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  // TODO: implement isClosed
  bool get isClosed => throw UnimplementedError();

  @override
  // TODO: implement state
  get state => throw UnimplementedError();

  @override
  // TODO: implement stream
  Stream get stream => throw UnimplementedError();
}
