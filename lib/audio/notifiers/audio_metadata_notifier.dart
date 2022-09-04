import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';

class CurrentAudioMetadataNotifier extends ValueNotifier<AudioMetadata> {
  CurrentAudioMetadataNotifier()
      : super(AudioMetadata(
          author: '',
          title: '',
          artUrl: kLogoUrl,
          id: '',
          url: '',
          isFavorite: false,
          isSeen: false,
          senderId: '',
          timeSent: DateTime.now(),
        ));
}
