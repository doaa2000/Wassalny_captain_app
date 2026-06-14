import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/captain_profile.dart';
import '../../domain/usecases/get_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required GetProfile getProfile})
      : _getProfile = getProfile,
        super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
  }

  final GetProfile _getProfile;

  Future<void> _onStarted(ProfileStarted event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getProfile(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: ProfileStatus.failure, errorMessage: f.message)),
      (profile) => emit(state.copyWith(status: ProfileStatus.ready, profile: profile)),
    );
  }
}
