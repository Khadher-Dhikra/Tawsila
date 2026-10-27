import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String displayName;
  final String phone;
  final String city;
  final bool isDriver;
  final double ratingAvg;
  final int ratingCount;
  final DateTime createdAt;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.phone,
    required this.city,
    this.isDriver = false,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    required this.createdAt,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return UserProfile(
      uid: doc.id,
      displayName: d['displayName'] as String? ?? '',
      phone: d['phone'] as String? ?? '',
      city: d['city'] as String? ?? '',
      isDriver: d['isDriver'] as bool? ?? false,
      ratingAvg: (d['ratingAvg'] as num?)?.toDouble() ?? 0,
      ratingCount: d['ratingCount'] as int? ?? 0,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'displayName': displayName,
        'phone': phone,
        'city': city,
        'isDriver': isDriver,
        'ratingAvg': ratingAvg,
        'ratingCount': ratingCount,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}