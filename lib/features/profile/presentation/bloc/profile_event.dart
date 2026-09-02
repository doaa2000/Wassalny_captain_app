part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileStarted extends ProfileEvent {
  const ProfileStarted();
}

class ProfileUpdated extends ProfileEvent {
  const ProfileUpdated({required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  List<Object?> get props => [name, phone];
}
