import 'dart:async';

import '../../models/booking.dart';
import '../../models/trip_session.dart';
import '../trip_session_repository.dart';

class FakeTripSessionRepository implements TripSessionRepository {
  static const fakeCode = '123456';

  final Map<String, TripSession> _sessions = {};
  final _changes = StreamController<void>.broadcast();

  @override
  Stream<TripSession?> watchSession(String bookingId) async* {
    yield _sessions[bookingId];
    await for (final _ in _changes.stream) {
      yield _sessions[bookingId];
    }
  }

  @override
  Future<String> generateCode(Booking booking) async {
    final now = DateTime.now();
    _sessions[booking.id] = TripSession(
      id: booking.id,
      rideId: booking.rideId,
      bookingId: booking.id,
      driverId: booking.driverId,
      passengerId: booking.passengerId,
      codeExpiresAt:
          now.add(const Duration(minutes: TripSession.codeValidityMinutes)),
      createdAt: now,
    );
    _changes.add(null);
    return fakeCode;
  }

  @override
  Future<String?> getMyCode(String bookingId) async =>
      _sessions.containsKey(bookingId) ? fakeCode : null;

  @override
  Future<bool> tryStart(String bookingId, String guess) async {
    final s = _sessions[bookingId];
    if (s == null) {
      throw StateError("Le passager n'a pas encore généré son code");
    }
    if (!s.canTryCode) {
      throw StateError('Code expiré ou nombre d\'essais dépassé');
    }
    final ok = guess == fakeCode;
    _sessions[bookingId] = _copy(
      s,
      attempts: s.attempts + 1,
      lastGuess: guess,
      status: ok ? TripSessionStatus.started : s.status,
      startedAt: ok ? DateTime.now() : null,
    );
    _changes.add(null);
    return ok;
  }

  @override
  Future<void> completeTrip(String bookingId) async {
    final s = _sessions[bookingId];
    if (s == null) return;
    _sessions[bookingId] = _copy(
      s,
      attempts: s.attempts,
      lastGuess: s.lastGuess,
      status: TripSessionStatus.completed,
      startedAt: s.startedAt,
    );
    _changes.add(null);
  }

  TripSession _copy(
    TripSession s, {
    required int attempts,
    required String lastGuess,
    required TripSessionStatus status,
    DateTime? startedAt,
  }) =>
      TripSession(
        id: s.id,
        rideId: s.rideId,
        bookingId: s.bookingId,
        driverId: s.driverId,
        passengerId: s.passengerId,
        codeExpiresAt: s.codeExpiresAt,
        attempts: attempts,
        lastGuess: lastGuess,
        status: status,
        startedAt: startedAt,
        createdAt: s.createdAt,
      );
}