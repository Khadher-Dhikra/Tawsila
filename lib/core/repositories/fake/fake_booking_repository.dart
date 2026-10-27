import 'dart:async';

import '../../models/booking.dart';
import '../booking_repository.dart';

class FakeBookingRepository implements BookingRepository {
  final List<Booking> _bookings = [];
  final _changes = StreamController<void>.broadcast();

  Stream<List<Booking>> _watch(List<Booking> Function() query) async* {
    yield query();
    await for (final _ in _changes.stream) {
      yield query();
    }
  }

  @override
  Future<String> createBooking(Booking booking) async {
    final id = 'b${_bookings.length + 1}';
    _bookings.add(Booking(
      id: id,
      rideId: booking.rideId,
      passengerId: booking.passengerId,
      passengerName: booking.passengerName,
      driverId: booking.driverId,
      seats: booking.seats,
      createdAt: DateTime.now(),
    ));
    _changes.add(null);
    return id;
  }

  @override
  Stream<List<Booking>> getBookingsByPassenger(String passengerId) =>
      _watch(() => _bookings.where((b) => b.passengerId == passengerId).toList());

  @override
  Stream<List<Booking>> getBookingsByRide(String rideId) =>
      _watch(() => _bookings.where((b) => b.rideId == rideId).toList());

  @override
  Future<void> acceptBooking(String bookingId) =>
      _setStatus(bookingId, BookingStatus.accepted);

  @override
  Future<void> rejectBooking(String bookingId) =>
      _setStatus(bookingId, BookingStatus.rejected);

  @override
  Future<void> cancelBooking(String bookingId) =>
      _setStatus(bookingId, BookingStatus.cancelled);

  Future<void> _setStatus(String bookingId, BookingStatus status) async {
    final i = _bookings.indexWhere((b) => b.id == bookingId);
    if (i == -1) return;
    final b = _bookings[i];
    _bookings[i] = Booking(
      id: b.id,
      rideId: b.rideId,
      passengerId: b.passengerId,
      passengerName: b.passengerName,
      driverId: b.driverId,
      seats: b.seats,
      status: status,
      createdAt: b.createdAt,
    );
    _changes.add(null);
  }
}