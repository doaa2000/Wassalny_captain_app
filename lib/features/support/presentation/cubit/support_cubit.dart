import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/support_content.dart';
import '../../domain/usecases/get_support_content.dart';

part 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit(this._getContent) : super(const SupportState());

  final GetSupportContent _getContent;

  Future<void> load() async {
    emit(state.copyWith(status: SupportStatus.loading));
    final result = await _getContent(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: SupportStatus.failure, errorMessage: f.message)),
      (content) => emit(state.copyWith(status: SupportStatus.ready, content: content)),
    );
  }
}
