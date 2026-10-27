import 'dart:async';

import '../../models/ride.dart';
import '../ride_repository.dart';

class FakeRideRepository implements RideRepository {
  final List<Ride> _rides = [
    Ride(
      id: 'r1',
      driverId: 'u1',
      driverName: 'Ahmed',
      fromCity: 'Sidi Bouzid',
      toCity: 'Tunis',
      departureTime: DateTime.now().add(const Duration(days: 1)),
      seatsTotal: 3,
      seatsAvailable: 3,
      pricePerSeat: 18,
      createdAt: DateTime.now(),
    ),
    Ride(
      id: 'r2',
      driverId: 'u2',
      driverName: 'Sana',
      fromCity: 'Sfax',
      toCity: 'Sousse',
      departureTime: DateTime.now().add(const Duration(days: 2)),
      seatsTotal: 4,
      seatsAvailable: 2,
      pricePerSeat: 12,
      createdAt: DateTime.now(),
    ),
  ];

  final _changes = StreamController<void>.broadcast();

  Stream<List<Ride>> _watch(List<Ride> Function() query) async* {
    yield query();
    await for (final _ in _changes.stream) {
      yield query();
    }
  }

  @override
  Stream<List<Ride>> getRides({String? fromCity, String? toCity, DateTime? date}) {
    return _watch(() => _rides.where((r) {
          if (r.status != RideStatus.open) return false;
          if (fromCity != null && r.fromCity != fromCity) return false;
          if (toCity != null && r.toCity != toCity) return false;
          if (date != null &&
              (r.departureTime.year != date.year ||
                  r.departureTime.month != date.month ||
                  r.departureTime.day != date.day)) {
            return false;
          }
          return true;
        }).toList());
  }

  @override
  Future<Ride?> getRide(String rideId) async {
    for (final r in _rides) {
      if (r.id == rideId) return r;
    }
    return null;
  }

  @override
  Stream<List<Ride>> getRidesByDriver(String driverId) =>
      _watch(() => _rides.where((r) => r.driverId == driverId).toList());

  @override
  Future<String> createRide(Ride ride) async {
    final id = 'r${_rides.length + 1}';
    _rides.add(Ride(
      id: id,
      driverId: ride.driverId,
      driverName: ride.driverName,
      fromCity: ride.fromCity,
      toCity: ride.toCity,
      departureTime: ride.departureTime,
      seatsTotal: ride.seatsTotal,
      seatsAvailable: ride.seatsTotal,
      pricePerSeat: ride.pricePerSeat,
      description: ride.description,
      createdAt: DateTime.now(),
    ));
    _changes.add(null);
    return id;
  }

  @override
  Future<void> cancelRide(String rideId) async {
    final i = _rides.indexWhere((r) => r.id == rideId);
    if (i == -1) return;
    final r = _rides[i];
    _rides[i] = Ride(
      id: r.id,
      driverId: r.driverId,
      driverName: r.driverName,
      fromCity: r.fromCity,
      toCity: r.toCity,
      departureTime: r.departureTime,
      seatsTotal: r.seatsTotal,
      seatsAvailable: r.seatsAvailable,
      pricePerSeat: r.pricePerSeat,
      description: r.description,
      status: RideStatus.cancelled,
      createdAt: r.createdAt,
    );
    _changes.add(null);
  }
}