import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/captain_profile.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileUpdated>(_onUpdated);
  }

  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;

  Future<void> _onStarted(ProfileStarted event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final result = await _getProfile(const NoParams());
    result.fold(
      (f) => emit(state.copyWith(status: ProfileStatus.failure, errorMessage: f.message)),
      (profile) => emit(state.copyWith(status: ProfileStatus.ready, profile: profile)),
    );
  }

  Future<void> _onUpdated(ProfileUpdated event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isSaving: true));
    final result = await _updateProfile(UpdateProfileParams(name: event.name, phone: event.phone));
    result.fold(
      (f) => emit(state.copyWith(isSaving: false, errorMessage: f.message)),
      (profile) => emit(state.copyWith(isSaving: false, profile: profile)),
    );
  }
}
