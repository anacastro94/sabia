import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';

final recordedAudioHandlerProvider =
    Provider((ref) => RecordedAudioHandler(ref: ref));

class RecordedAudioHandler {
  RecordedAudioHandler({required this.ref}) {
    _init();
  }
  final ProviderRef ref;
  late AudioMetadata _audioMetadata;

  void _init() {
    _audioMetadata = _getBlankAudioMetadata();
  }

  AudioMetadata get audioMetadata => _audioMetadata;

  void updateAudioMetadata({
    String? author,
    String? title,
    String? artUrl,
    String? id,
    String? url,
    bool? isFavorite,
    bool? isSeen,
    String? senderId,
    DateTime? timeSent,
  }) {
    _audioMetadata = _audioMetadata.copyWith(
      author: author,
      title: title,
      artUrl: artUrl,
      id: id,
      url: url,
      isFavorite: isFavorite,
      isSeen: isSeen,
      senderId: senderId,
      timeSent: timeSent,
    );
  }

  void clear() {
    _audioMetadata = _getBlankAudioMetadata();
  }

  AudioMetadata _getBlankAudioMetadata() {
    return AudioMetadata(
      author: '',
      title: '',
      artUrl: kLogoUrl,
      id: '',
      url: '',
      isFavorite: false,
      isSeen: false,
      senderId: '',
      timeSent: DateTime.now(),
    );
  }
}
