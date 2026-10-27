import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, accepted, rejected, cancelled }

class Booking {
  final String id;
  final String rideId;
  final String passengerId;
  final String passengerName;
  final String driverId;
  final int seats;
  final BookingStatus status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.rideId,
    required this.passengerId,
    required this.passengerName,
    required this.driverId,
    this.seats = 1,
    this.status = BookingStatus.pending,
    required this.createdAt,
  });

  factory Booking.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Booking(
      id: doc.id,
      rideId: d['rideId'] as String? ?? '',
      passengerId: d['passengerId'] as String? ?? '',
      passengerName: d['passengerName'] as String? ?? '',
      driverId: d['driverId'] as String? ?? '',
      seats: d['seats'] as int? ?? 1,
      status: BookingStatus.values.firstWhere(
        (s) => s.name == d['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'rideId': rideId,
        'passengerId': passengerId,
        'passengerName': passengerName,
        'driverId': driverId,
        'seats': seats,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}