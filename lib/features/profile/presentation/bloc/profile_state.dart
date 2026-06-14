part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, ready, failure }

class ProfileState extends Equatable {
  const ProfileState({this.status = ProfileStatus.initial, this.profile, this.errorMessage});

  final ProfileStatus status;
  final CaptainProfile? profile;
  final String? errorMessage;

  ProfileState copyWith({ProfileStatus? status, CaptainProfile? profile, String? errorMessage}) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
