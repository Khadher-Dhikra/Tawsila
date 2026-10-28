import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/booking.dart';
import '../../models/trip_session.dart';
import '../trip_session_repository.dart';

class FirebaseTripSessionRepository implements TripSessionRepository {
  final FirebaseFirestore _db;

  FirebaseTripSessionRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _session(String id) =>
      _db.collection('tripSessions').doc(id);

  DocumentReference<Map<String, dynamic>> _secret(String id) =>
      _db.collection('tripSecrets').doc(id);

  @override
  Stream<TripSession?> watchSession(String bookingId) =>
      _session(bookingId).snapshots().map(
            (d) => d.exists ? TripSession.fromFirestore(d) : null,
          );

  @override
  Future<String> generateCode(Booking booking) async {
    final rnd = Random.secure();
    final code =
        List.generate(TripSession.codeLength, (_) => rnd.nextInt(10)).join();
    final now = DateTime.now();

    // -2 min de marge : les règles refusent une date > 30 min côté serveur
    final session = TripSession(
      id: booking.id,
      rideId: booking.rideId,
      bookingId: booking.id,
      driverId: booking.driverId,
      passengerId: booking.passengerId,
      codeExpiresAt:
          now.add(const Duration(minutes: TripSession.codeValidityMinutes - 2)),
      createdAt: now,
    );

    final batch = _db.batch();
    batch.set(_secret(booking.id), {
      'passengerId': booking.passengerId,
      'code': code,
    });
    batch.set(_session(booking.id), session.toMap());
    await batch.commit();
    return code;
  }

  @override
  Future<String?> getMyCode(String bookingId) async {
    final doc = await _secret(bookingId).get();
    return doc.data()?['code'] as String?;
  }

  @override
  Future<bool> tryStart(String bookingId, String guess) async {
    final snap = await _session(bookingId).get();
    if (!snap.exists) {
      throw StateError("Le passager n'a pas encore généré son code");
    }
    final s = TripSession.fromFirestore(snap);
    if (!s.canTryCode) {
      throw StateError('Code expiré ou nombre d\'essais dépassé');
    }

    // 1) enregistrer l'essai (compté par les règles)
    await _session(bookingId).update({
      'lastGuess': guess,
      'attempts': FieldValue.increment(1),
    });

    // 2) démarrer : les règles comparent avec le vrai code
    try {
      await _session(bookingId).update({
        'status': TripSessionStatus.started.name,
        'startedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') return false;
      rethrow;
    }
  }

  @override
  Future<void> completeTrip(String bookingId) => _session(bookingId)
      .update({'status': TripSessionStatus.completed.name});
}