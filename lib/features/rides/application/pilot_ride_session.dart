import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pilot/features/rides/data/ride_repository.dart';

final pilotOnlineProvider = StateProvider<bool>((ref) => false);

final pilotOfferProvider = StateNotifierProvider<PilotOfferController, AsyncValue<Map<String, dynamic>?>>(
  (ref) => PilotOfferController(ref),
);

class PilotOfferController extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  PilotOfferController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;
  Timer? _poll;

  PilotRideRepository get _repo => _ref.read(pilotRideRepositoryProvider);

  void startPolling() {
    _poll?.cancel();
    _tick();
    _poll = Timer.periodic(const Duration(seconds: 2), (_) => _tick());
  }

  void stopPolling() {
    _poll?.cancel();
    state = const AsyncValue.data(null);
  }

  Future<void> _tick() async {
    try {
      final active = await _repo.active();
      if (active != null) {
        state = AsyncValue.data(active);
        return;
      }
      final offers = await _repo.offers();
      state = AsyncValue.data(offers.isEmpty ? null : offers.first);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => _tick();

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }
}
