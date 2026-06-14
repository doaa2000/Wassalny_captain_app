part of 'dashboard_bloc.dart';

enum DashboardStatus { initial, loading, ready, failure }

class DashboardState extends Equatable {
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.online = true,
    this.summary,
    this.requests = const [],
    this.errorMessage,
  });

  final DashboardStatus status;
  final bool online;
  final DashboardSummary? summary;
  final List<RideRequest> requests;
  final String? errorMessage;

  DashboardState copyWith({
    DashboardStatus? status,
    bool? online,
    DashboardSummary? summary,
    List<RideRequest>? requests,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      online: online ?? this.online,
      summary: summary ?? this.summary,
      requests: requests ?? this.requests,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, online, summary, requests, errorMessage];
}
