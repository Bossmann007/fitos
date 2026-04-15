// lib/features/treinos/presentation/providers/rest_timer_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestTimerState {
  final int totalSeconds;
  final int remaining;
  final bool isRunning;

  const RestTimerState({
    this.totalSeconds = 60,
    this.remaining = 60,
    this.isRunning = false,
  });

  bool get isFinished => remaining <= 0;
  double get progress =>
      totalSeconds > 0 ? remaining / totalSeconds : 0.0;
}

final restTimerProvider =
    StateNotifierProvider<RestTimerNotifier, RestTimerState>(
  (_) => RestTimerNotifier(),
);

class RestTimerNotifier extends StateNotifier<RestTimerState> {
  Timer? _timer;

  RestTimerNotifier() : super(const RestTimerState());

  void start(int seconds) {
    _timer?.cancel();
    state = RestTimerState(
        totalSeconds: seconds, remaining: seconds, isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remaining <= 1) {
        _timer?.cancel();
        state = RestTimerState(
            totalSeconds: state.totalSeconds,
            remaining: 0,
            isRunning: false);
      } else {
        state = RestTimerState(
            totalSeconds: state.totalSeconds,
            remaining: state.remaining - 1,
            isRunning: true);
      }
    });
  }

  void stop() {
    _timer?.cancel();
    state = RestTimerState(
        totalSeconds: state.totalSeconds,
        remaining: state.remaining,
        isRunning: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
