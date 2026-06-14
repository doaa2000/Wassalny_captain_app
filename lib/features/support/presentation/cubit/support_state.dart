part of 'support_cubit.dart';

enum SupportStatus { initial, loading, ready, failure }

class SupportState extends Equatable {
  const SupportState({this.status = SupportStatus.initial, this.content, this.errorMessage});

  final SupportStatus status;
  final SupportContent? content;
  final String? errorMessage;

  SupportState copyWith({SupportStatus? status, SupportContent? content, String? errorMessage}) {
    return SupportState(
      status: status ?? this.status,
      content: content ?? this.content,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, content, errorMessage];
}
