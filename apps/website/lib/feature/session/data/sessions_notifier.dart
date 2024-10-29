import 'package:common_data/session.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sessions_notifier.g.dart';

@Riverpod(keepAlive: true)
Future<List<SessionVenuesWithSessions>> sessions(Ref ref) async {
  final repository = ref.watch(sessionRepositoryProvider);
  return repository.fetchSessionVenuesWithSessions();
}

typedef SessionsWithSessionVenue = ({
  SessionVenuesWithSessions sessionVenue,
  SessionWithSpeakerAndSponsor session,
});

enum EventDate {
  day1(2024, 11, 21),
  day2(2024, 11, 22),
  ;

  const EventDate(this.year, this.month, this.day);

  final int year;
  final int month;
  final int day;
}

@riverpod
Future<List<SessionVenuesWithSessions>> sessionsByDate(
  Ref ref,
  EventDate date,
) async {
  final sessions = await ref.watch(sessionsProvider.future);
  return sessions.where((venue) {
    return venue.sessions.any((session) {
      final sessionDate = session.startsAt.toLocal();
      return sessionDate.year == date.year &&
          sessionDate.month == date.month &&
          sessionDate.day == date.day;
    });
  }).toList();
}
