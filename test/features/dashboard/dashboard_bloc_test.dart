import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wassalny_captain/core/errors/failures.dart';
import 'package:wassalny_captain/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:wassalny_captain/features/dashboard/domain/usecases/set_online_status.dart';
import 'package:wassalny_captain/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:wassalny_captain/features/trip/domain/usecases/get_nearby_requests.dart';

class _MockGetSummary extends Mock implements GetDashboardSummary {}

class _MockSetOnline extends Mock implements SetOnlineStatus {}

class _MockGetNearby extends Mock implements GetNearbyRequests {}

void main() {
  late _MockGetSummary getSummary;
  late _MockSetOnline setOnline;
  late _MockGetNearby getNearby;

  setUp(() {
    getSummary = _MockGetSummary();
    setOnline = _MockSetOnline();
    getNearby = _MockGetNearby();
  });

  DashboardBloc buildBloc() =>
      DashboardBloc(getSummary: getSummary, setOnline: setOnline, getNearbyRequests: getNearby);

  group('DashboardBloc.toggle', () {
    blocTest<DashboardBloc, DashboardState>(
      'optimistically flips online then confirms with the backend value',
      setUp: () => when(() => setOnline(false)).thenAnswer((_) async => const Right(false)),
      build: buildBloc,
      seed: () => const DashboardState(status: DashboardStatus.ready, online: true),
      act: (bloc) => bloc.add(const DashboardOnlineToggled()),
      expect: () => [
        const DashboardState(status: DashboardStatus.ready, online: false),
      ],
      verify: (_) => verify(() => setOnline(false)).called(1),
    );

    blocTest<DashboardBloc, DashboardState>(
      'reverts the optimistic toggle when the backend call fails',
      setUp: () =>
          when(() => setOnline(false)).thenAnswer((_) async => const Left(ServerFailure())),
      build: buildBloc,
      seed: () => const DashboardState(status: DashboardStatus.ready, online: true),
      act: (bloc) => bloc.add(const DashboardOnlineToggled()),
      expect: () => [
        const DashboardState(status: DashboardStatus.ready, online: false),
        const DashboardState(status: DashboardStatus.ready, online: true),
      ],
    );
  });
}
