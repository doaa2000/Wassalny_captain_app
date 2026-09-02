part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, ready, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.isSaving = false,
  });

  final ProfileStatus status;
  final CaptainProfile? profile;
  final String? errorMessage;
  final bool isSaving;

  ProfileState copyWith({
    ProfileStatus? status,
    CaptainProfile? profile,
    String? errorMessage,
    bool? isSaving,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, isSaving];
}
