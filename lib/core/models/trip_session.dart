import 'package:cloud_firestore/cloud_firestore.dart';

enum TripSessionStatus { waiting, started, completed, locked }

class TripSession {
  static const int codeValidityMinutes = 30;
  static const int maxAttempts = 3;

  final String id;
  final String rideId;
  final String bookingId;
  final String driverId;
  final String passengerId;
  final String startCode;
  final DateTime codeExpiresAt;
  final int attempts;
  final TripSessionStatus status;
  final DateTime? startedAt;
  final DateTime createdAt;

  const TripSession({
    required this.id,
    required this.rideId,
    required this.bookingId,
    required this.driverId,
    required this.passengerId,
    required this.startCode,
    required this.codeExpiresAt,
    this.attempts = 0,
    this.status = TripSessionStatus.waiting,
    this.startedAt,
    required this.createdAt,
  });

  bool get isCodeExpired => DateTime.now().isAfter(codeExpiresAt);
  bool get canTryCode =>
      status == TripSessionStatus.waiting &&
      !isCodeExpired &&
      attempts < maxAttempts;

  factory TripSession.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return TripSession(
      id: doc.id,
      rideId: d['rideId'] as String? ?? '',
      bookingId: d['bookingId'] as String? ?? '',
      driverId: d['driverId'] as String? ?? '',
      passengerId: d['passengerId'] as String? ?? '',
      startCode: d['startCode'] as String? ?? '',
      codeExpiresAt: (d['codeExpiresAt'] as Timestamp).toDate(),
      attempts: d['attempts'] as int? ?? 0,
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
        'startCode': startCode,
        'codeExpiresAt': Timestamp.fromDate(codeExpiresAt),
        'attempts': attempts,
        'status': status.name,
        'startedAt': startedAt == null ? null : Timestamp.fromDate(startedAt!),
        'createdAt': Timestamp.fromDate(createdAt),
      };
}