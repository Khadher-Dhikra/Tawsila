import 'package:cloud_firestore/cloud_firestore.dart';

enum TripSessionStatus { waiting, started, completed }

class TripSession {
  static const int codeValidityMinutes = 30;
  static const int maxAttempts = 3;
  static const int codeLength = 6;

  /// Même id que la réservation (1 session par réservation)
  final String id;
  final String rideId;
  final String bookingId;
  final String driverId;
  final String passengerId;
  final DateTime codeExpiresAt;
  final int attempts;
  final String lastGuess;
  final TripSessionStatus status;
  final DateTime? startedAt;
  final DateTime createdAt;

  const TripSession({
    required this.id,
    required this.rideId,
    required this.bookingId,
    required this.driverId,
    required this.passengerId,
    required this.codeExpiresAt,
    this.attempts = 0,
    this.lastGuess = '',
    this.status = TripSessionStatus.waiting,
    this.startedAt,
    required this.createdAt,
  });

  bool get isCodeExpired => DateTime.now().isAfter(codeExpiresAt);
  bool get isLocked => attempts >= maxAttempts;
  bool get canTryCode =>
      status == TripSessionStatus.waiting && !isCodeExpired && !isLocked;

  factory TripSession.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return TripSession(
      id: doc.id,
      rideId: d['rideId'] as String? ?? '',
      bookingId: d['bookingId'] as String? ?? '',
      driverId: d['driverId'] as String? ?? '',
      passengerId: d['passengerId'] as String? ?? '',
      codeExpiresAt: (d['codeExpiresAt'] as Timestamp).toDate(),
      attempts: d['attempts'] as int? ?? 0,
      lastGuess: d['lastGuess'] as String? ?? '',
      status: TripSessionStatus.values.firstWhere(
        (s) => s.name == d['status'],
        orElse: () => TripSessionStatus.waiting,
      ),
      startedAt: (d['startedAt'] as Timestamp?)?.toDate(),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'rideId': rideId,
        'bookingId': bookingId,
        'driverId': driverId,
        'passengerId': passengerId,
        'codeExpiresAt': Timestamp.fromDate(codeExpiresAt),
        'attempts': attempts,
        'lastGuess': lastGuess,
        'status': status.name,
        'startedAt': startedAt == null ? null : Timestamp.fromDate(startedAt!),
        'createdAt': Timestamp.fromDate(createdAt),
      };
}