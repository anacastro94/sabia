import 'package:bbk_final_ana/common/constants/constants.dart';

abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist();
  Future<Map<String, String>> fetchAnotherAudio();
}

class FirebasePlaylistRepository extends PlaylistRepository {
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist() {
    // TODO: implement fetchInitialPlaylist
    throw UnimplementedError();
  }

  @override
  Future<Map<String, String>> fetchAnotherAudio() async {
    return _nextAudio();
  }

  // TODO: Update this consider the actual item in the database
  int _audioIndex = 0;
  static const _maxAudioNumber = 16;
  Map<String, String> _nextAudio() {
    _audioIndex = (_audioIndex % _maxAudioNumber) + 1;
    return {
      'id': _audioIndex.toString().padLeft(3, '0'),
      'title': 'Song $_audioIndex',
      'author': 'SoundHelix',
      'artwork': kLogoUrl,
      'url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_audioIndex.mp3',
    };
  }
}
