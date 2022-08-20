import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerProgressStateProvider =
    StateProvider<PlayerProgressState>((ref) => PlayerProgressState(
          current: Duration.zero,
          buffered: Duration.zero,
          total: Duration.zero,
        ));

class PlayerProgressState {
  PlayerProgressState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}
