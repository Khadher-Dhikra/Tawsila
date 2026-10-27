import 'package:cloud_firestore/cloud_firestore.dart';

enum RideStatus { open, full, cancelled, completed }

class Ride {
  final String id;
  final String driverId;
  final String driverName;
  final String fromCity;
  final String toCity;
  final DateTime departureTime;
  final int seatsTotal;
  final int seatsAvailable;
  final double pricePerSeat;
  final String description;
  final RideStatus status;
  final DateTime createdAt;

  const Ride({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.fromCity,
    required this.toCity,
    required this.departureTime,
    required this.seatsTotal,
    required this.seatsAvailable,
    required this.pricePerSeat,
    this.description = '',
    this.status = RideStatus.open,
    required this.createdAt,
  });

  factory Ride.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Ride(
      id: doc.id,
      driverId: d['driverId'] as String? ?? '',
      driverName: d['driverName'] as String? ?? '',
      fromCity: d['fromCity'] as String? ?? '',
      toCity: d['toCity'] as String? ?? '',
      departureTime: (d['departureTime'] as Timestamp).toDate(),
      seatsTotal: d['seatsTotal'] as int? ?? 0,
      seatsAvailable: d['seatsAvailable'] as int? ?? 0,
      pricePerSeat: (d['pricePerSeat'] as num?)?.toDouble() ?? 0,
      description: d['description'] as String? ?? '',
      status: RideStatus.values.firstWhere(
        (s) => s.name == d['status'],
        orElse: () => RideStatus.open,
      ),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'driverId': driverId,
        'driverName': driverName,
        'fromCity': fromCity,
        'toCity': toCity,
        'departureTime': Timestamp.fromDate(departureTime),
        'seatsTotal': seatsTotal,
        'seatsAvailable': seatsAvailable,
        'pricePerSeat': pricePerSeat,
        'description': description,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}