import '../models/booking.dart';
import '../models/trip_session.dart';

abstract class TripSessionRepository {
  /// null tant que le passager n'a pas généré son code
  Stream<TripSession?> watchSession(String bookingId);

  /// Passager : génère le code à 6 chiffres et le retourne
  Future<String> generateCode(Booking booking);

  /// Passager : relit son propre code
  Future<String?> getMyCode(String bookingId);

  /// Conducteur : true si le trajet démarre, false si le code est faux
  Future<bool> tryStart(String bookingId, String guess);

  Future<void> completeTrip(String bookingId);
}