import '../models/booking.dart';

abstract class BookingRepository {
  Future<String> createBooking(Booking booking);
  Stream<List<Booking>> getBookingsByPassenger(String passengerId);
  Stream<List<Booking>> getBookingsByRide(String rideId);
  Future<void> acceptBooking(String bookingId);
  Future<void> rejectBooking(String bookingId);
  Future<void> cancelBooking(String bookingId);
}
