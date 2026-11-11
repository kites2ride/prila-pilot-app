import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:pilot/features/rides/data/ride_repository.dart';

/// Sends latest GPS only while online (no queue of old points).
/// Interval / distance from bootstrap when wired; defaults match dispatch config (4s / 20m).
class LocationUpdateStrategy {
  LocationUpdateStrategy(this._repo, {this.intervalSec = 4, this.distanceM = 20});

  final PilotRideRepository _repo;
  final int intervalSec;
  final int distanceM;

  StreamSubscription<Position>? _sub;
  Timer? _fallback;

  Future<void> start() async {
    await stop();
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    _sub = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceM,
      ),
    ).listen((pos) {
      unawaited(_send(pos));
    });

    // Also tick on interval so we refresh even if still
    _fallback = Timer.periodic(Duration(seconds: intervalSec), (_) async {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        await _send(pos);
      } catch (_) {}
    });
  }

  Future<void> _send(Position pos) async {
    await _repo.updateLocation(
      lat: pos.latitude,
      lng: pos.longitude,
    );
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    _fallback?.cancel();
    _fallback = null;
  }
}
