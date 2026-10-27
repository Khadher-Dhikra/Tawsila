import '../models/ride.dart';

abstract class RideRepository {
  Stream<List<Ride>> getRides({String? fromCity, String? toCity, DateTime? date});
  Future<Ride?> getRide(String rideId);
  Stream<List<Ride>> getRidesByDriver(String driverId);
  Future<String> createRide(Ride ride);
  Future<void> cancelRide(String rideId);
}