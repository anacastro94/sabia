import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/play_button_enum.dart';

final playerButtonStateProvider =
    StateProvider<PlayerButtonState>((ref) => PlayerButtonState.paused);
