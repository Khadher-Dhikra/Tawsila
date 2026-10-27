import 'package:cloud_firestore/cloud_firestore.dart';

enum ReportStatus { open, reviewed, closed }

class Report {
  final String id;
  final String reporterId;
  final String reportedUserId;
  final String? rideId;
  final String reason;
  final String details;
  final ReportStatus status;
  final DateTime createdAt;

  const Report({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    this.rideId,
    required this.reason,
    this.details = '',
    this.status = ReportStatus.open,
    required this.createdAt,
  });

  factory Report.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Report(
      id: doc.id,
      reporterId: d['reporterId'] as String? ?? '',
      reportedUserId: d['reportedUserId'] as String? ?? '',
      rideId: d['rideId'] as String?,
      reason: d['reason'] as String? ?? '',
      details: d['details'] as String? ?? '',
      status: ReportStatus.values.firstWhere(
        (s) => s.name == d['status'],
        orElse: () => ReportStatus.open,
      ),
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'reporterId': reporterId,
        'reportedUserId': reportedUserId,
        'rideId': rideId,
        'reason': reason,
        'details': details,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}