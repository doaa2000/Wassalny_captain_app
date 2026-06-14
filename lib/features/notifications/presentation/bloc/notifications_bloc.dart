import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../../domain/usecases/get_notifications.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc({
    required GetNotifications getNotifications,
    required NotificationsRepository repository,
  })  : _getNotifications = getNotifications,
        _repository = repository,
        super(const NotificationsState()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationsCleared>(_onCleared);
  }

  final GetNotifications _getNotifications;
  final NotificationsRepository _repository;

  Future<void> _onStarted(NotificationsStarted event, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    final result = await _getNotifications(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: NotificationsStatus.failure, errorMessage: f.message)),
      (items) => emit(state.copyWith(status: NotificationsStatus.ready, items: items)),
    );
  }

  Future<void> _onCleared(NotificationsCleared event, Emitter<NotificationsState> emit) async {
    await _repository.clearAll();
    emit(state.copyWith(status: NotificationsStatus.ready, items: const []));
  }
}
